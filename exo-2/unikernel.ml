(* this is the full unikernel code *)

open V1_LWT
open Lwt.Infix

module State: sig

  type t
  (** The type for proxy state. *)

  val create: control_port:int -> t
  (** Create a new proxy state. [control] is the control port
      number. *)

  val ports: t -> int list
  (** [ports t] is the sequence of port knocking stored in the
      state. *)

  val add: t -> int -> unit
  (** [add t port] add [port] to the current observed sequence of
      ports. *)

  val reset: t -> unit
  (** [reset t] resets the proxy state. *)

  val control_port: t -> int
  (** [control_port t] is [t]'s control port number. *)

end = struct

  type t = {
    control_port: int;
    mutable ports: int list; (* sequence of ports *)
  }

  let create ~control_port = { control_port; ports = [] }
  let add t p = t.ports <- p :: t.ports
  let ports t = List.rev t.ports
  let reset t = t.ports <- []
  let control_port t = t.control_port
end

module Hostname (C: CONSOLE): sig

  val decode: C.t -> State.t -> string option
  (** Resolve port knocks into hostname. *)

end = struct

  let log c fmt = Printf.ksprintf (C.log c) fmt

  (* the ports table *)
  let table = [
    [1]   , "reseau-loops.github.io";
    [1; 2], "unikernel.org";
  ]

  let decode c t =
    let ports = State.ports t in
    log c "decode [%s]" (String.concat ", " @@ List.map string_of_int ports);
    try Some (List.assoc ports table) with Not_found -> None

end

module Main (C: CONSOLE) (S: STACKV4) = struct

  (* helpers *)
  let log c fmt = Printf.ksprintf (C.log_s c) fmt

  let ok_or_error dbg c = function
    | `Ok r    -> Lwt.return r
    | `Error _ ->
      log c "Error: %s" dbg >>= fun () ->
      Lwt.fail_with ("Error: " ^ dbg)
    | `Eof     ->
      log c "Eof: %s" dbg >>= fun () ->
      Lwt.fail_with ("Eof: " ^ dbg)

  (* the proxy function *)
  let proxy c con host =
    log c "Found port combination for host %s!" host >>= fun () ->
    let buf =
      Printf.sprintf
        "<html><body style=\"background-color:green\">\
         <center style=\"color:white\">found: %s!</center>\
         </body></html>"
        host
    in
    let buf = Cstruct.of_string buf in
    S.TCPV4.write con buf >>=
    ok_or_error "reply_one" c >>= fun () ->
    S.TCPV4.close con

  module Hostname = Hostname(C)

  let not_found c con =
    log c "No port combination found!" >>= fun () ->
    let buf =
      "<html><body style=\"background-color:blue\">\
       <center style=\"color:white\">Hello Loops!</center>\
       </body></html>"
    in
    let buf = Cstruct.of_string buf in
    S.TCPV4.write con buf >>=
    ok_or_error "reply_one" c >>= fun () ->
    S.TCPV4.close con

  let reply_one c t con =
    log c "Reply!" >>= fun () ->
    match Hostname.decode c t with
    | Some host -> proxy c con host
    | None      -> not_found c con

  type request =
    | Reset
    | Unknown of string

  let string_of_request buf =
    match String.trim (Cstruct.to_string buf) with
    | "reset" -> Reset
    | req     -> Unknown req

  let update c t port flow =
    match port - State.control_port t with
    | 0 ->
      S.TCPV4.read flow >>= fun question ->
      ok_or_error "update" c question >>= fun buf ->
      begin match string_of_request buf with
        | Reset ->
          log c "Port 0: RESET!" >>= fun () ->
          State.reset t;
          S.TCPV4.close flow
        | Unknown req ->
          log c "Port 0: Unknwon request (%s)" req >>= fun () ->
          S.TCPV4.close flow
      end
    | port ->
      log c "Port %d: PING!" port >>= fun () ->
      State.add t port;
      S.TCPV4.close flow

  let get_ip s = match S.IPV4.get_ip (S.ipv4 s) with
    | []   -> "<not set>"
    | h::_ -> Ipaddr.V4.to_string h

  let start c s =
    log c "\n\
          \    --------------------\n\
          \    |   Hello Loops!   |\n\
          \    |                  |\n\
          \    |   /exercice 2/   |\n\
          \    --------------------\n"
    >>= fun () ->
    log c " == exercice 2 == " >>= fun () ->
    log c "My IP address is: %s" (get_ip s) >>= fun () ->
    let control_port = 999 in
    let t = State.create ~control_port in
    (* register an handler for all the ports we are interested in *)
    for i = 0 to 256 do
      let port = control_port + i in
      S.listen_tcpv4 s ~port (update c t port)
    done;
    S.listen_tcpv4 s ~port:80 (reply_one c t);
    S.listen s

end

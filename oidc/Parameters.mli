(** Auth parameters *)

type display = Page | Popup | Touch | Wap

type prompt = None | Login | Consent | Select_account

type t = {
  response_type : string list;
  client : Client.t;
  redirect_uri : Uri.t;
  scope : string list;
  state : string option;
  nonce : string option;
  claims : Yojson.Safe.t option;
  max_age : int option;
  display : display option;
  prompt : prompt option;
}

val make :
  ?response_type:string list ->
  ?scope:string list ->
  ?state:string ->
  ?claims:Yojson.Safe.t ->
  ?max_age:int ->
  ?display:display ->
  ?prompt:prompt ->
  ?nonce:string ->
  Client.t ->
  redirect_uri:Uri.t ->
  t

val to_query : t -> (string * string list) list
(** Used when starting a authentication *)

(** {2 Parsing in the provider } *)

type error = [
  | `Unauthorized_client of Client.t
  | `Missing_client
  | `Invalid_scope of string list
  | `Invalid_redirect_uri of string
  | `Missing_parameter of string
  | `Invalid_display of string
  | `Invalid_prompt of string
]
(** Possible states when parsing the query *)

val parse_query : clients:Client.t list -> Uri.t -> (t, [> error]) result

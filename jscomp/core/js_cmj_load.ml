(* Copyright (C) Authors of BuckleScript
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

(* strategy:
   If not installed, use the distributed [cmj] files, 
   make sure that the distributed files are platform independent
*)




#if BS_BROWSER  then 
let find_cmj_exn file : Js_cmj_format.cmj_load_info = 
  let target = Ext_string.uncapitalize_ascii (Filename.basename file) in
  match Builtin_cmj_datasets.query_by_name target with
  | Some v
    -> 
    {package_path = "BROWSER"; cmj_table = v}
  | None
    ->     
    Bs_exception.error (Cmj_not_found file)
#else    
let find_cmj_exn file : Js_cmj_format.cmj_load_info = 
  match Config_util.find_opt file with
  | Some f
    -> 
    {package_path = 
      (** hacking relying on the convention of pkg/lib/ocaml/xx.cmj*)
      Filename.dirname (Filename.dirname (Filename.dirname f)); 
      cmj_table =  Js_cmj_format.from_file f}
  | None -> 
    (* ONLY read the stored cmj data in browser environment *)
    Bs_exception.error (Cmj_not_found file)

#end
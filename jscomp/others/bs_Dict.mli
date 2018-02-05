
(* Copyright (C) 2017 Authors of BuckleScript
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


(** {!Bs.Dict}
    
    Provide utiliites to create identified comparators or hashes for 
    data structures used below. 
    
    It create a unique identifer per module of functions so that different data structures with slightly different 
    comparison functions won't mix.
*)



type ('a, 'id) hash
(** [('a, 'id) hash]

    Its runtime represenation is a [hash] function, but signed with a 
    type parameter, so that different hash functions type mismatch
*) 

type ('a, 'id) eq 
(** [('a, 'id) eq]
 
    Its runtime represenation is an [eq] function, but signed with a 
    type parameter, so that different hash functions type mismatch
*) 

type ('a, 'id) cmp
(** [('a,'id) cmp]
  
    Its runtime representation is a [cmp] function, but signed with a 
    type parameter, so that different hash functions type mismatch
*)
    
module type Comparable = sig
  type id
  type t
  val cmp: (t, id) cmp
end

type ('key, 'id) comparable =
  (module Comparable with type t = 'key and type id = 'id)
(** [('key, 'id) cmparable] is a module of functions, here it only includes [cmp].

    Unlike normal functions, when created, it comes with a unique identity (guaranteed
    by the type system). 
    
    It can be created using function {!comparable}
   
    The idea of a unique identity when created is that it makes sure two sets would type 
    mismatch if they use different comparison function
*)

val comparableU:
  cmp:('a -> 'a -> int [@bs]) ->
  (module Comparable with type t = 'a)

val comparable:
  cmp:('a -> 'a -> int) -> 
  (module Comparable with type t = 'a)
  
module type Hashable = sig 
  type id 
  type t 
  val hash: (t,id) hash
  val eq:  (t,id) eq
end 

type ('key, 'id) hashable =
  (module Hashable with type t = 'key and type id = 'id)
(** [('key, 'id) hashable] is a module of functions, here it only includes [hash], [eq].
    
    Unlike normal functions, when created, it comes with a unique identity (guaranteed
    by the type system). 
    
    It can be created using function {!hashable}

    The idea of a unique identity when created is that it makes sure two hash sets would type 
    mismatch if they use different comparison function
*)

                            

val hashableU:
  hash:('a -> int [@bs]) ->
  eq:('a -> 'a -> bool [@bs]) ->
  (module Hashable with type t = 'a)
  
val hashable:
  hash:('a -> int ) ->
  eq:('a -> 'a -> bool ) ->
  (module Hashable with type t = 'a)



(**/**)
external getHashInternal : ('a,'id) hash -> ('a -> int [@bs]) = "%identity"
external getEqInternal : ('a, 'id) eq -> ('a -> 'a -> bool [@bs]) = "%identity"
external getCmpInternal : ('a,'id) cmp -> ('a -> 'a -> int [@bs]) = "%identity"
(**/**)

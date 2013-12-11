(**************************************************************************)
(*                                                                        *)
(*    Copyright 2012 INRIA                                                *)
(*    Copyright 2012-2013 OCamlPro                                        *)
(*    Copyright 2013 David Sheets                                         *)
(*                                                                        *)
(*  All rights reserved.This file is distributed under the terms of the   *)
(*  GNU Lesser General Public License version 3.0 with linking            *)
(*  exception.                                                            *)
(*                                                                        *)
(*  OPAM is distributed in the hope that it will be useful, but WITHOUT   *)
(*  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY    *)
(*  or FITNESS FOR A PARTICULAR PURPOSE.See the GNU General Public        *)
(*  License for more details.                                             *)
(*                                                                        *)
(**************************************************************************)

type 'a pkg = {
  name : string;
  version : string;
  descr : 'a;
  synopsis : string;
  href : Uri.t;
  title : string;
  update : float;
  url : OpamFile.URL.t option;
}

type repository = Path of string | Local of string | Opam
type pred =
    Tag of string
  | Depopt
  | Not of pred
  | Repo of string
  | Pkg of string
type index = Index_pred | Index_all
type 'a t = {
  repos : OpamTypes.repository OpamTypes.repository_name_map;
  preds : pred list list;
  index : index;
  pkg_idx : (OpamTypes.repository_name * string option) OpamTypes.package_map;
  versions : OpamTypes.version_set OpamTypes.name_map;
  max_packages : OpamTypes.package_set;
  max_versions : OpamTypes.version OpamTypes.name_map;
  reverse_deps : OpamTypes.name_set OpamTypes.name_map;
  pkgs_infos : 'a pkg option OpamTypes.package_map;
  pkgs_opams : OpamFile.OPAM.t OpamTypes.package_map;
  pkgs_dates : float OpamTypes.package_map;
}

module Repo : sig val links : OpamTypes.repository -> OpamFile.Repo.t end

module Pkg : sig
  val to_repo : 'a t -> OpamPackage.Map.key -> OpamTypes.repository
  val are_preds_satisfied : 'a t -> OpamPackage.Map.key -> bool
  val href :
    ?href_base:Uri.t ->
    OpamPackage.Name.t -> OpamPackage.Version.t -> Uri.t
  val get_info :
    dates:float OpamPackage.Map.t ->
    OpamTypes.repository ->
    string option -> OpamTypes.package -> (string * string) pkg option
end

val of_repositories :
  ?preds:pred list list -> index -> repository list -> (string * string) t

val map : ('a -> 'b) -> 'a t -> 'b t

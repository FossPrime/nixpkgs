{ lib, stdenv, fetchFromGitHub, cmake, vtk_9, libX11, libGL, Cocoa, OpenGL }:

stdenv.mkDerivation rec {
  pname = "f3d";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "f3d-app";
    repo = "f3d";
    rev = "refs/tags/v${version}";
    hash = "sha256-3Pg8uvrUGPKPmsn24q5HPMg9dgvukAXBgSVTW0NiCME=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ vtk_9 ] ++ lib.optionals stdenv.isDarwin [ Cocoa OpenGL ];

  # conflict between VTK and Nixpkgs;
  # see https://github.com/NixOS/nixpkgs/issues/89167
  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
  ];

  meta = with lib; {
    description = "Fast and minimalist 3D viewer using VTK";
    homepage = "https://f3d-app.github.io/f3d";
    changelog = "https://github.com/f3d-app/f3d/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
    platforms = with platforms; unix;
    # As of 2024-01-20, this fails with:
    # error while loading shared libraries: libvtkInteractionWidgets.so.1: cannot open shared object file: No such file or directory
    # Tracking issue: https://github.com/NixOS/nixpkgs/issues/262328
    broken = true;
  };
}

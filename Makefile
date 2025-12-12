#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#            This file is part of the DpdGraph tools.
#  Copyright (C) 2009-2025 Anne Pacalet (Anne.Pacalet@free.fr)
#                      and Yves Bertot (Yves.Bertot@inria.fr)
#      This file is distributed under the terms of the
#       GNU Lesser General Public License Version 2.1
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

main_target : all

all install uninstall test test-suite clean clean_test : Make_coq
	$(MAKE) -f $< $@

Make_coq : Make
	rocq makefile -f $< -o $@

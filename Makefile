#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#            This file is part of the DpdGraph tools.
#  Copyright (C) 2009-2025 Anne Pacalet (Anne.Pacalet@free.fr)
#                      and Yves Bertot (Yves.Bertot@inria.fr)
#      This file is distributed under the terms of the
#       GNU Lesser General Public License Version 2.1
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

NAME=coq-dpdgraph
VERSION=1.0-9.0

main_target : all

all install uninstall test test-suite clean clean_test : Make_coq
	make -f $< $@

Make_coq : Make
	rocq makefile -f $< -o $@

#-------------------------------------------------------------------------------
DISTRIBUTED+=Makefile LICENSE README.md configure Makefile.in

distrib : $(NAME)-$(VERSION).tgz

%.tgz : clean
	$(ECHO_CIBLE)
	rm -rf $* $@
	mkdir $*
	cp --parents $(DISTRIBUTED) $*
	tar zcvf $@ $*
	rm -rf $*
	$(ECHO) "Don't forget to copy README.md and $@ on the server if needed"


#-------------------------------------------------------------------------------
# testing


#-------------------------------------------------------------------------------
clean_coq : Make_coq
	$(MAKE) -f $< clean

#-------------------------------------------------------------------------------

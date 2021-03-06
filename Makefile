# Copyright (c) 2018 Sine Nomine Associates

help:
	@echo "usage: make <target> [<target> ...]"
	@echo ""
	@echo "Packaging targets:"
	@echo "  sdist          create source distribution"
	@echo "  wheel          create wheel distribution"
	@echo "  rpm            create rpm package"
	@echo "  deb            create deb package"
	@echo ""
	@echo "Installation targets:"
	@echo "  install        install package"
	@echo "  uninstall      uninstall package"
	@echo "  install-user   user mode install"
	@echo "  uninstall-user user mode uninstall"
	@echo "  install-dev    developer mode install"
	@echo "  uninstall-dev  developer mode uninstall"
	@echo ""
	@echo "Development targets:"
	@echo "  lint           run python linter"
	@echo "  checkdocs      validate documents"
	@echo "  test           run unit tests"
	@echo "  clean          delete generated files"
	@echo "  distclean      delete generated and config files"

Makefile.config: configure.py
	python configure.py > $@

include Makefile.config

generated: OpenAFSLibrary/__version__.py

OpenAFSLibrary/__version__.py:
	echo "VERSION = '$(VERSION)'" >$@

lint: generated
	$(PYFLAKES) OpenAFSLibrary/*.py OpenAFSLibrary/keywords/*.py

checkdocs: # requires collection.checkdocs
	$(PYTHON) setup.py checkdocs

test: generated
	$(PYTHON) -m unittest -v test

sdist: generated
	$(PYTHON) setup.py sdist

wheel: generated
	$(PYTHON) setup.py bdist_wheel

rpm: generated
	$(PYTHON) setup.py bdist_rpm

deb: generated
	$(PYTHON) setup.py --command-packages=stdeb.command bdist_deb

install: generated
	$(MAKE) -f Makefile.$(INSTALL) $@

install-user: generated
	$(MAKE) -f Makefile.$(INSTALL) $@

install-dev: generated
	$(MAKE) -f Makefile.$(INSTALL) $@

uninstall:
	$(MAKE) -f Makefile.$(INSTALL) $@

uninstall-user:
	$(MAKE) -f Makefile.$(INSTALL) $@

uninstall-dev:
	$(MAKE) -f Makefile.$(INSTALL) $@

clean:
	rm -f *.pyc test/*.pyc OpenAFSLibrary/*.pyc OpenAFSLibrary/keywords/*.pyc
	rm -fr $(NAME).egg-info/ build/ dist/
	rm -fr $(NAME)*.tar.gz deb_dist/
	rm -f MANIFEST

distclean: clean
	rm -f OpenAFSLibary/__version__.py
	rm -f Makefile.config
	rm -f files.txt

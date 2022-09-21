PKG_ROOT    = .
PKG_VERSION = $(shell awk '/^Version:/{print $$2}' $(PKG_ROOT)/DESCRIPTION)
PKG_NAME    = $(shell awk '/^Package:/{print $$2}' $(PKG_ROOT)/DESCRIPTION)

CRAN = "https://cran.rstudio.com"

# General Package Dependencies
DATASOURCES = $(wildcard $(PKG_ROOT)/data-raw/*.json)
DATATARGETS = R/sysdata.rda
RFILES      = $(wildcard $(PKG_ROOT)/R/*.R)
TESTS       = $(wildcard $(PKG_ROOT)/tests/*.R)
VIGNETTES   = $(wildcard $(PKG_ROOT)/vignettes/*.Rmd)

################################################################################
# Recipes

.PHONY: all check check-as-cran install uninstall clean covr-report.html

all: $(PKG_NAME)_$(PKG_VERSION).tar.gz

$(PKG_NAME)_$(PKG_VERSION).tar.gz: .install_dev_deps.Rout .document.Rout $(VIGNETTES) $(TESTS)
	R CMD build --md5 $(build-options) $(PKG_ROOT)

.install_dev_deps.Rout : $(PKG_ROOT)/DESCRIPTION
	Rscript --vanilla --quiet -e "options(repo = c('$(CRAN)'))" \
		-e "if (!require(devtools)) {install.packages('devtools', repo = c('$(CRAN)'))}" \
		-e "options(warn = 2)" \
		-e "devtools::install_dev_deps()"
	touch $@

.document.Rout: $(SRC) $(RFILES) $(DATATARGETS) $(PKG_ROOT)/DESCRIPTION
	Rscript --vanilla --quiet -e "options(warn = 2)" \
		-e "devtools::document('$(PKG_ROOT)')"
	touch $@

$(DATATARGETS) : data-raw/create_sysdata.R $(DATASOURCES)
	Rscript --vanilla --quiet $<
	#R --vanilla \
		#-e 'files <- list.files(normalizePath("./data-raw"), pattern = "*\\.json", full.names = TRUE)'\
		#-e 'names(files) <- sub("\\.json", "", basename(files))'\
		#-e "if (!require(jsonlite)) {install.packages('jsonlite', repo = c('$(CRAN)'))}" \
		#-e '.zpalettes <- lapply(files, jsonlite::fromJSON)'\
		#-e 'save(.zpalettes, file = "./R/sysdata.rda")'

check: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD check $(PKG_NAME)_$(PKG_VERSION).tar.gz

check-as-cran: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD check --as-cran $(PKG_NAME)_$(PKG_VERSION).tar.gz

covr-report.html : $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R --vanilla --quiet -e 'x <- covr::package_coverage(type = "test")'\
		-e 'print(x)'\
		-e 'covr::report(x, file = "$@")'

install: $(PKG_NAME)_$(PKG_VERSION).tar.gz
	R CMD INSTALL $(PKG_NAME)_$(PKG_VERSION).tar.gz

uninstall :
	R --vanilla --quiet -e "try(remove.packages('$(PKG_NAME).data'), silent = TRUE)"

clean:
	$(RM) -f  $(PKG_NAME)_$(PKG_VERSION).tar.gz
	$(RM) -rf $(PKG_NAME).Rcheck
	$(RM) -f .document.Rout
	$(RM) -f .install_dev_deps.Rout


APP_DIR = /Applications
SCRIVENER_DIR = Scrivener.app/Contents
SCRIVENER_ROOT = $(APP_DIR)/$(SCRIVENER_DIR)
RESOURCES_SRCDIR = $(SCRIVENER_ROOT)/Resources/ja.lproj
SPARKLE_SRCDIR = $(SCRIVENER_ROOT)/Frameworks/Sparkle.framework/Versions/A/Resources/ja.lproj
PADDLE_SRCDIR = $(SCRIVENER_ROOT)/Frameworks/Paddle.framework/Versions/A/Resources/ja.lproj
AUTOUPDATE_SRCDIR = $(SCRIVENER_ROOT)/Frameworks/Sparkle.framework/Versions/A/Resources/Autoupdate.app/Contents/Resources/ja.lproj
APPKIT_SRCDIR = $(SCRIVENER_ROOT)/Frameworks/ScrAppKit.framework/Versions/A/Resources/ja.lproj

ORIG_DIR = orig
FIX_DIR = fix

RESOURCES_DIR = Resources
SPARKLE_DIR = Sparkle
PADDLE_DIR = Paddle
APPKIT_DIR = SrcAppKit
AUTOUPDATE_DIR = Autoupdate

RESOURCES_ORIGDIR = $(ORIG_DIR)/$(RESOURCES_DIR)
SPARKLE_ORIGDIR = $(ORIG_DIR)/$(SPARKLE_DIR)
PADDLE_ORIGDIR = $(ORIG_DIR)/$(PADDLE_DIR)
APPKIT_ORIGDIR = $(ORIG_DIR)/$(APPKIT_DIR)
AUTOUPDATE_ORIGDIR = $(ORIG_DIR)/$(AUTOUPDATE_DIR)

RESOURCES_FIXDIR = $(FIX_DIR)/$(RESOURCES_DIR)
SPARKLE_FIXDIR = $(FIX_DIR)/$(SPARKLE_DIR)
PADDLE_FIXDIR = $(FIX_DIR)/$(PADDLE_DIR)
APPKIT_FIXDIR = $(FIX_DIR)/$(APPKIT_DIR)
AUTOUPDATE_FIXDIR = $(FIX_DIR)/$(AUTOUPDATE_DIR)

RESOURCES_STR = $(notdir $(wildcard $(RESOURCES_SRCDIR)/*.strings))
SPARKLE_STR = $(notdir $(wildcard $(SPARKLE_SRCDIR)/*.strings))
AUTOUPDATE_STR = $(notdir $(wildcard $(AUTOUPDATE_SRCDIR)/*.strings))
PADDLE_STR = $(notdir $(wildcard $(PADDLE_SRCDIR)/*.strings))
APPKIT_STR = $(notdir $(wildcard $(APPKIT_SRCDIR)/*.strings))

RESOURCES_NIB = $(subst $(RESOURCES_SRCDIR)/,,$(shell find $(RESOURCES_SRCDIR) -type f -name "*.nib"))
SPARKLE_NIB = $(subst $(SPARKLE_SRCDIR)/,,$(shell find $(SPARKLE_SRCDIR) -type f -name "*.nib"))
APPKIT_NIB = $(subst $(APPKIT_SRCDIR)/,,$(shell find $(APPKIT_SRCDIR) -type f -name "*.nib"))

RESOURCES_XML = $(subst $(RESOURCES_DSTDIR)/,,$(shell find $(RESOURCES_DSTDIR) -type f -name "*.xml"))
SPARKLE_XML = $(subst $(SPARKLE_DSTDIR)/,,$(shell find $(SPARKLE_DSTDIR) -type f -name "*.xml))
APPKIT_XML = $(subst $(APPKIT_DSTDIR)/,,$(shell find $(APPKIT_DSTDIR) -type f -name "*.xml"))

TARBALL = $(shell pwd)/Scrivener-ja-patch_$(shell date "+%Y%m%d").tar.xz

ZIPARC = $(shell pwd)/Scrivener-ja-patch_$(shell date "+%Y%m%d").zip

ARCFILES = $(shell diff -rq fix orig | grep -e '.xml' -e '.strings' | cut -d ' ' -f2 | sed -e 's/.xml/.nib/' -e 's|fix/||' -e 's|$(RESOURCES_DIR)|$(RESOURCES_SRCDIR)|' -e 's|$(SPARKLE_DIR)|$(SPARKLE_SRCDIR)|' -e 's|$(PADDLE_DIR)|$(PADDLE_SRCDIR)|' -e 's|$(APPKIT_DIR)|$(APPKIT_SRCDIR)|' -e 's|$(APP_DIR)/||')

all:
	echo $(RESOURCES_STR)
	echo $(SPARKLE_STR)
	echo $(PADDLE_STR)
	echo $(AUTOUPDATE_STR)
	echo $(APPKIT_STR)
	echo $(RESOURCES_SRCDIR)
	echo $(RESOURCES_NIB)
	echo $(SPARKLE_NIB)
	echo $(PADDLE_NIB)
	echo $(APPKIT_NIB)

save:
	cp -rp $(RESOURCES_SRCDIR)/* $(ORIG_DIR)/$(RESOURCES_DSTDIR)
	cp -rp $(SPARKLE_SRCDIR)/* $(ORIG_DIR)/$(SPARKLE_DSTDIR)
	cp -rp $(PADDLE_SRCDIR)/* $(ORIG_DIR)/$(PADDLE_DSTDIR)
	cp -rp $(APPKIT_SRCDIR)/* $(ORIG_DIR)/$(APPKIT_DSTDIR)
	cp -rp $(AUTOUPDATE_SRCDIR)/* $(ORIG_DIR)/$(AUTOUPDATE_DSTDIR)
	cp -p $(ORIG_DIR)/$(RESOURCES_DSTDIR)/*.strings $(FIX_DIR)/$(RESOURCES_DSTDIR)
	cp -p $(ORIG_DIR)/$(SPARKLE_DSTDIR)/*.strings $(FIX_DIR)/$(RESOURCES_DSTDIR)
	cp -p $(ORIG_DIR)/$(PADDLE_DSTDIR)/*.strings $(FIX_DIR)/$(RESOURCES_DSTDIR)
	cp -p $(ORIG_DIR)/$(APPKIT_DSTDIR)/*.strings $(FIX_DIR)/$(RESOURCES_DSTDIR)

xml:
	@find $(ORIG_DIR) -type f -name "*.nib" -exec plutil -convert xml1 -e xml {} ¥;

nib:
	@echo "Converting XML files into .nib..."
	@find $(FIX_DIR) -type f -name "*.xml" -exec plutil -convert binary1 -e nib {} \;

install:
	@echo "Installing modified .nib files..."
	@cp -rp $(RESOURCES_FIXDIR)/*.nib $(RESOURCES_FIXDIR)/*.strings $(RESOURCES_SRCDIR)
	@cp -rp $(SPARKLE_FIXDIR)/*.nib $(SPARKLE_FIXDIR)/*.strings $(SPARKLE_SRCDIR)
	@cp -rp $(PADDLE_FIXDIR)/*.strings $(PADDLE_SRCDIR)
	@cp -rp $(APPKIT_FIXDIR)/*.nib $(APPKIT_FIXDIR)/*.strings $(APPKIT_SRCDIR)

tar: nib install
	@echo "Creating a tar ball $(notdir $(TARBALL))..."
	@(cd $(APP_DIR); tar cfJ $(TARBALL) $(ARCFILES))
	@echo "Done."

zip: nib install
	@echo "Creating a zipped archive $(notdir $(ZIPARC))..."
	@(cd $(APP_DIR); zip -rq $(ZIPARC) $(ARCFILES))
	@echo "Done."
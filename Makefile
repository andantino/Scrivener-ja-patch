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
STR_DIR = strings

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


# AboutPanel.strings:                   text/plain; charset=utf-16le
# Aspose.strings:                       text/plain; charset=utf-16le
# AuthorizedPathsPanel.strings:         text/plain; charset=utf-16le
# AutoCompleteList.strings:             text/plain; charset=utf-16le
# BackupTo.strings:                     text/plain; charset=utf-16le
# Bookmarks.strings:                    text/plain; charset=utf-16le
# BookmarksView.strings:                text/plain; charset=utf-16le
# CommentPopoverView.strings:           text/plain; charset=utf-16le
# CompileDraft.strings:                 text/plain; charset=utf-8
# CompileFormatEditorView.strings:      text/plain; charset=utf-8
# CompileFormats.strings:               text/plain; charset=utf-8
# CompileSectionsLayoutChooser.strings: text/plain; charset=utf-16le
# ConvertScriptPanel.strings:           text/plain; charset=utf-16le
# CustomMetaDataInspectorView.strings:  text/plain; charset=utf-16le
# DocumentView.strings:                 text/plain; charset=utf-8
# EditBookmarkPopover.strings:          text/plain; charset=utf-16le
# ExportFiles.strings:                  text/plain; charset=utf-8
# FormatFinder.strings:                 text/plain; charset=utf-16le
# FullScreen.strings:                   text/plain; charset=utf-16le
# HelpViewer.strings:                   text/plain; charset=utf-16le
# IconManager.strings:                  text/plain; charset=utf-16le
# IconNames.strings:                    text/plain; charset=utf-16le
# ImageTools.strings:                   text/plain; charset=utf-16le
# ImportSheets.strings:                 text/plain; charset=utf-8
# IndentsAndTabsPanel.strings:          text/plain; charset=utf-16le
# InfoPlist.strings:                    text/plain; charset=utf-16le
# InspectorView.strings:                text/plain; charset=utf-8
# KBCrashReporter.strings:              text/plain; charset=utf-16le
# KBDatePickerPopover.strings:          text/plain; charset=utf-16le
# KBExceptionReporter.strings:          text/plain; charset=utf-16le
# KBFindPanel.strings:                  text/plain; charset=utf-16le
# KBTextImageResizer.strings:           text/plain; charset=utf-16le
# KeywordsOutlineView.strings:          text/plain; charset=utf-16le
# KeywordsPanel.strings:                text/plain; charset=utf-16le
# KindleGenQuarantineWindow.strings:    text/plain; charset=utf-16le
# Layouts.strings:                      text/plain; charset=utf-8
# LegacyCompileFormatChooser.strings:   text/plain; charset=utf-16le
# LinguisticFocus.strings:              text/plain; charset=utf-16le
# LinkSheet.strings:                    text/plain; charset=utf-16le
# LoadingPanel.strings:                 text/plain; charset=utf-16le
# Localizable.strings:                  text/plain; charset=utf-8
# MainDocument.strings:                 text/plain; charset=utf-8
# MainMenu.strings:                     text/plain; charset=utf-8
# NameGenerator.strings:                text/plain; charset=utf-16le
# NameLists.strings:                    text/plain; charset=utf-16le
# NewBookmarkFolderChooser.strings:     text/plain; charset=utf-16le
# NewClippingSheet.strings:             text/plain; charset=utf-16le
# NewScrivenerLink.strings:             text/plain; charset=utf-16le
# Newsletter.strings:                   text/plain; charset=utf-16le
# PageLayout.strings:                   text/plain; charset=utf-16le
# Preferences.strings:                  text/plain; charset=utf-8
# ProjectPrefs.strings:                 text/plain; charset=utf-16le
# ProjectSettings.strings:              text/plain; charset=utf-8
# ProjectStatistics.strings:            text/plain; charset=utf-16le
# ProjectTemplates.strings:             text/plain; charset=utf-16le
# QuickRefView.strings:                 text/plain; charset=utf-16le
# QuickReferencePanel.strings:          text/plain; charset=utf-16le
# QuotesPanel.strings:                  text/plain; charset=utf-16le
# Replace.strings:                      text/plain; charset=utf-16le
# SaveAsTemplate.strings:               text/plain; charset=utf-16le
# ScratchPad.strings:                   text/plain; charset=utf-16le
# ScriptFormats.strings:                text/plain; charset=utf-16le
# ScriptSettingsSheet.strings:          text/plain; charset=utf-8
# ScrivxConflicts.strings:              text/plain; charset=utf-16le
# SectionTypes.strings:                 text/plain; charset=utf-16le
# ServicesMenu.strings:                 text/plain; charset=utf-16le
# Snapshots.strings:                    text/plain; charset=utf-8
# SnapshotsManager.strings:             text/plain; charset=utf-16le
# StartupPanel.strings:                 text/plain; charset=utf-16le
# StatisticsPopover.strings:            text/plain; charset=utf-16le
# StylesManager.strings:                text/plain; charset=utf-16le
# StylesPanel.strings:                  text/plain; charset=utf-16le
# StylesUpdateSheet.strings:            text/plain; charset=utf-16le
# SyncBinderStringsPanel.strings:       text/plain; charset=utf-16le
# SyncWithFolder.strings:               text/plain; charset=utf-16le
# SynopsisFinder.strings:               text/plain; charset=utf-16le
# TargetsPanel.strings:                 text/plain; charset=utf-16le
# Templates.strings:                    text/plain; charset=utf-16le
# TextFormatBar.strings:                text/plain; charset=utf-16le
# TextScaleSheet.strings:               text/plain; charset=utf-16le
# ToolbarSearchResults.strings:         text/plain; charset=utf-16le
# UnicodeIconSheet.strings:             text/plain; charset=utf-16le
# UpdateProject.strings:                text/plain; charset=utf-16le
# WritingHistorySheet.strings:          text/plain; charset=utf-16le

STR_UTF8 = \
$(STR_DIR)/CompileDraft.strings \
$(STR_DIR)/CompileFormatEditorView.strings \
$(STR_DIR)/CompileFormats.strings \
$(STR_DIR)/DocumentView.strings \
$(STR_DIR)/ExportFiles.strings \
$(STR_DIR)/ImportSheets.strings \
$(STR_DIR)/InspectorView.strings \
$(STR_DIR)/Layouts.strings \
$(STR_DIR)/Localizable.strings \
$(STR_DIR)/MainDocument.strings \
$(STR_DIR)/MainMenu.strings \
$(STR_DIR)/Preferences.strings \
$(STR_DIR)/ProjectSettings.strings \
$(STR_DIR)/ScriptSettingsSheet.strings \
$(STR_DIR)/Snapshots.strings \


STR_UTF16LE = \
$(STR_DIR)/AboutPanel.strings \
$(STR_DIR)/Aspose.strings \
$(STR_DIR)/AuthorizedPathsPanel.strings \
$(STR_DIR)/AutoCompleteList.strings \
$(STR_DIR)/BackupTo.strings \
$(STR_DIR)/Bookmarks.strings \
$(STR_DIR)/BookmarksView.strings \
$(STR_DIR)/CommentPopoverView.strings \
$(STR_DIR)/CompileSectionsLayoutChooser.strings \
$(STR_DIR)/ConvertScriptPanel.strings \
$(STR_DIR)/CustomMetaDataInspectorView.strings \
$(STR_DIR)/EditBookmarkPopover.strings \
$(STR_DIR)/FormatFinder.strings \
$(STR_DIR)/FullScreen.strings \
$(STR_DIR)/HelpViewer.strings \
$(STR_DIR)/IconManager.strings \
$(STR_DIR)/IconNames.strings \
$(STR_DIR)/ImageTools.strings \
$(STR_DIR)/IndentsAndTabsPanel.strings \
$(STR_DIR)/InfoPlist.strings \
$(STR_DIR)/KBCrashReporter.strings \
$(STR_DIR)/KBDatePickerPopover.strings \
$(STR_DIR)/KBExceptionReporter.strings \
$(STR_DIR)/KBFindPanel.strings \
$(STR_DIR)/KBTextImageResizer.strings \
$(STR_DIR)/KeywordsOutlineView.strings \
$(STR_DIR)/KeywordsPanel.strings \
$(STR_DIR)/KindleGenQuarantineWindow.strings \
$(STR_DIR)/LegacyCompileFormatChooser.strings \
$(STR_DIR)/LinguisticFocus.strings \
$(STR_DIR)/LinkSheet.strings \
$(STR_DIR)/LoadingPanel.strings \
$(STR_DIR)/NameGenerator.strings \
$(STR_DIR)/NameLists.strings \
$(STR_DIR)/NewBookmarkFolderChooser.strings \
$(STR_DIR)/NewClippingSheet.strings \
$(STR_DIR)/NewScrivenerLink.strings \
$(STR_DIR)/Newsletter.strings \
$(STR_DIR)/PageLayout.strings \
$(STR_DIR)/ProjectPrefs.strings \
$(STR_DIR)/ProjectStatistics.strings \
$(STR_DIR)/ProjectTemplates.strings \
$(STR_DIR)/QuickRefView.strings \
$(STR_DIR)/QuickReferencePanel.strings \
$(STR_DIR)/QuotesPanel.strings \
$(STR_DIR)/Replace.strings \
$(STR_DIR)/SaveAsTemplate.strings \
$(STR_DIR)/ScratchPad.strings \
$(STR_DIR)/ScriptFormats.strings \
$(STR_DIR)/ScrivxConflicts.strings \
$(STR_DIR)/SectionTypes.strings \
$(STR_DIR)/ServicesMenu.strings \
$(STR_DIR)/SnapshotsManager.strings \
$(STR_DIR)/StartupPanel.strings \
$(STR_DIR)/StatisticsPopover.strings \
$(STR_DIR)/StylesManager.strings \
$(STR_DIR)/StylesPanel.strings \
$(STR_DIR)/StylesUpdateSheet.strings \
$(STR_DIR)/SyncBinderStringsPanel.strings \
$(STR_DIR)/SyncWithFolder.strings \
$(STR_DIR)/SynopsisFinder.strings \
$(STR_DIR)/TargetsPanel.strings \
$(STR_DIR)/Templates.strings \
$(STR_DIR)/TextFormatBar.strings \
$(STR_DIR)/TextScaleSheet.strings \
$(STR_DIR)/ToolbarSearchResults.strings \
$(STR_DIR)/UnicodeIconSheet.strings \
$(STR_DIR)/UpdateProject.strings \
$(STR_DIR)/WritingHistorySheet.strings \

toutf8: $(STR_UTF16LE)
	@$(STR_DIR)/to_utf8 $(STR_UTF16LE)

toutf16le: $(STR_UTF16LE)
	@$(STR_DIR)/to_utf16le $(STR_UTF16LE)
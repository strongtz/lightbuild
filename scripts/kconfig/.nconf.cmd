cmd_/disk/d/code/product/lightcore/scripts/kconfig/nconf := gcc  -o /disk/d/code/product/lightcore/scripts/kconfig/nconf /disk/d/code/product/lightcore/scripts/kconfig/nconf.o /disk/d/code/product/lightcore/scripts/kconfig/zconf.tab.o /disk/d/code/product/lightcore/scripts/kconfig/nconf.gui.o  -lncursesw -lmenuw -Wl,-O1,--sort-common,--as-needed,-z,relro,-z,now -lpanelw
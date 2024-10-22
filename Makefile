path = ~/.lexaloffle/pico-8/carts/

all: install

install:
	# copy new game files
	@cp "game.p8" ${path}
	@cp "doors.lua" ${path}
	@cp "handlers.lua" ${path}
	@cp "items.lua" ${path}
	@cp "main.lua" ${path}
	@cp "plates.lua" ${path}
	@cp "utility.lua" ${path}
	@cp "spritesheet.png" ${path}

clean:
	# remove old files
	@rm -r ${path}
	@mkdir ${path}

reinstall: install clean
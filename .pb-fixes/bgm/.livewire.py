# Original code livewire and EZH aka Forrest Setup
# USB Version changes and other updates by 2Play!
# New Randomizing Option By EnsignRutherFord aka russlb
# PlayBox Project
# 22.01.2021

import os
import pwd
import grp
import time
import random
#import pygame # if you don't have pygame: sudo apt-get install python-pygame
#also that line is commented out as we import the mixer specifically a bit further down.

###CONFIG SECTION###
startdelay = 0 # Value (in seconds) to delay audio start.  If you have a splash screen with audio and the script is playing music over the top of it, increase this value to delay the script from starting.
musicdir = '/home/pi/RetroPie/roms/music'
maxvolume = 1.0
volumefadespeed = 0.02
restart = False # If true, this will cause the script to fade the music out and -stop- the song rather than pause it.
startsong = "" # if this is not blank, this is the EXACT, CaSeSeNsAtIvE filename of the song you always want to play first on boot.

###Local Variables###
bgm = [mp3 for mp3 in os.listdir(musicdir) if mp3[-4:] == ".mp3" or mp3[-4:] == ".ogg"] # Find everything that's .mp3 or .ogg
played = [0] * len(bgm) # keep an array to track what has been played
lastsong = -1
currentsong = -1
playedsongs = 0 # track the number of uniquely played songs 
from pygame import mixer # import PyGame's music mixer
mixer.init() # Prep that bad boy up.
random.seed()
volume = maxvolume # Store this for later use to handle fading out.

#TODO: Fill in all of the current RetroPie Emulator process names in this list.
emulatornames = ["retroarch","ags","uae4all2","uae4arm","capriceRPI","linapple","hatari","stella","atari800","xroar","vice","vice.sh","daphne.sh","reicast","reicast.elf","reicast_awave.elf","reicast_naomi.elf","reicast_awave","reicast_naomi","pifba","osmose","gpsp","jzintv","basiliskll","BasiliskII","mame","advmame","advmess","dgen","openmsx","mupen64plus","gngeo","dosbox","PPSSPPSDL","ppsspp","lr-ppsspp","simcoupe","scummvm","snes9x","pisnes","frotz","fbzx","fuse","gemrb","cgenesis","zdoom","eduke32","lincity","love","kodi","alephone","micropolis","openbor","OpenBOR","OpenBOR_galina","openttd","opentyrian","cannonball","tyrquake","ioquake3","residualvm","xrick","sdlpop","uqm","stratagus","solarus-run","smw","drastic","psp","amiberry","fm7","redream","redream.elf","oricutron","cdogs-sdl","cgenius","descent2","descent1","digger","doom","duke3d","giana_rpi","coolcv_pi","cyclone","fruitbox","as1600","dasm1600","minivmac","np2","pcsx","fba2x","px68k","quasi88.sdl","rpix86","sdltrs","ti99sim-sdl","xm7","zesarux","omxplayer.bin","omxplayer","loader","d1x-rebirth","d2x-rebirth","zsdx","zsxd","zelda_roth_se","beebem","beebem0.13pi3","beebem0.13pi4","CGeniusExe","PicoDrive1.81","PicoDrive1.92","mednafen","yabause","darkplaces-sdl","prince","Xorg","wolf4sdl.sh","wolf4sdl-3dr-v14","wolf4sdl-gt-v14","wolf4sdl-spear","wolf4sdl-sw-v14","xvic","xvic cart","xplus4","xpet","x128","x64sc","x64","breaker","amphetamine","MalditaCastilla","SuperCrateBox","TheyNeedToBeFed","cap32","fillets","abuse","piegalaxy","PieGalaxy.sh","wyvern","innoextract","bgdi-330","splitwolf-wolf3","OpenJazz","openjk_sp.arm","openjk_mp.arm","openjk.arm","xash3d", "lzdoom","gzdoom","sorr","bgdi","doom1mods","doom2mods","doomumods","hexen2","hcl","openjkded.arm","iowolfsp.armv71","rtcw","iowolfded.armv7l","iowolfmp.armv7l","bstone","hurrican","sdl2trs","supertux2","VVVVVV","fury","jumpnbump","ioquake3.arm","srb2","MysticMine","duckstation-qt","duckstation-sdl","duckstation-qt","pico8_dyn","ssam","ssam-tfe","gemrb","abbayev2","arx","spelunky_classic_hd_html5","iowolfsp.arm","iowolfmp.arm","openclaw","openmw","openmw-launcher","openmw-wizard","xash3d","openjk","openjk.openjk-sp","openjk.openjo-sp","bstone","libd2game_sa_arm.exe.so","qpdfview","captain","nblood","avp","hypseus","GSplus","dhewm3"]

#test: Ran into some issues with script crashing on a cold boot, so we're camping for emulationstation (if ES can start, so can we!)
esStarted = False
while not esStarted:
	time.sleep(1)
	pids = [pid for pid in os.listdir('/proc') if pid.isdigit()]
	for pid in pids:
		try:
			procname = open(os.path.join('/proc',pid,'comm'),'rb').read()
			if procname[:-1] == "emulationstatio": # Emulation Station's actual process name is apparently short 1 letter.
				esStarted=True
		except IOError:
			continue

#ES Should be going, see if we need to delay our start

if startdelay > 0:
	time.sleep(startdelay) # Delay audio start per config option above

#Look for OMXplayer - if it's running, someone's got a splash screen going!
pids = [pid for pid in os.listdir('/proc') if pid.isdigit()]
for pid in pids:
	try:
		procname = open(os.path.join('/proc',pid,'comm'),'rb').read()
		if procname[:-1] == "omxplayer" or procname[:-1] == "omxplayer.bin": # Looking for a splash screen!
			while os.path.exists('/proc/'+pid):
				time.sleep(1) #OMXPlayer is running, sleep 1 to prevent the need for a splash.
	except IOError:
		continue

#Check for a starting song
if not startsong == "":
	try:
		currentsong = bgm.index(startsong) #Set the currentsong to the index in BGM that is our startingsong.
	except:
		currentsong = -1 #If this triggers, you probably screwed up the filename, because our startsong wasn't found in the list.

#This is where the magic happens.
while True:
	while not esStarted: #New check (4/23/16) - Make sure EmulationStation is actually started.  There is code further down that, as part of the emulator loop, makes sure eS is running.
		if mixer.music.get_busy():
			mixer.music.stop(); #halt the music, emulationStation is not running!
		time.sleep(10)
		pids = [pid for pid in os.listdir('/proc') if pid.isdigit()]
		for pid in pids:
			try:
				procname = open(os.path.join('/proc',pid,'comm'),'rb').read()
				if procname[:-1] == "emulationstatio": # Emulation Station's actual process name is apparently short 1 letter.
					esStarted=True # Will cause us to break out of the loop because ES is now running.
			except IOError:
				continue

	#Check to see if the DisableMusic file exists; if it does, stop doing everything!
	if os.path.exists('/home/pi/.DisableMusic'):
		if mixer.music.get_busy():
			mixer.music.stop();
		while (os.path.exists('/home/pi/.DisableMusic')):
			time.sleep(5)

        #
        # Need a better randomizer... play every song randomly until we've played them all, then reset and do it again
        #
	if not mixer.music.get_busy(): # We aren't currently playing any music
		while currentsong == lastsong and len(bgm) > 1:	#If we have more than one BGM, choose a new one until we get one that isn't what we just played.
			currentsong = random.randint(0,len(bgm)-1)
                        while played[currentsong] == 1:
			        currentsong = random.randint(0, len(bgm) - 1)
                # print("currentsong:  ", currentsong)
                playedsongs = playedsongs + 1
                played[currentsong] = 1
		song = os.path.join(musicdir,bgm[currentsong])
                if playedsongs == len(bgm): # reset to replay all songs randomly
                        # print("resetting. need to make sure last song of the playlist doesn't get played first")
                        firstsong = currentsong
                        playedsongs = 0
                        played = [0] * len(bgm)
                # write the current song name to a file
                log_file = open('/home/pi/.playing_song.log', "w")
                n = log_file.write('Playing song: ' + song + '\n')
                log_file.close()
                # make 'pi' user the owner of the file
                os.chown('/home/pi/.playing_song.log', pwd.getpwnam("pi").pw_uid, grp.getgrnam("pi").gr_gid)

                # load and play song
		mixer.music.load(song)
		lastsong=currentsong
		mixer.music.set_volume(maxvolume) # Pygame sets this to 1.0 on new song; in case max volume -isnt- 1, set it to max volume.
		mixer.music.play()

	#Emulator check
	pids = [pid for pid in os.listdir('/proc') if pid.isdigit()]
	emulator = -1;
	esStarted=False #New check 4-23-16 - set this to False (assume ES is no longer running until proven otherwise)
	for pid in pids:
		try:
			procname = open(os.path.join('/proc',pid,'comm'),'rb').read()
			if procname[:-1] == "emulationstatio": # Killing 2 birds with one stone, while we look for emulators, make sure EmulationStation is still running.
					esStarted=True # And turn it back to True, because it wasn't done running.  This will prevent the loop above from stopping the music.
                    
			if procname[:-1] in emulatornames: #If the process name is in our list of known emulators
				emulator = pid;
				#Turn down the music
				#print "Emulator found! " + procname[:-1] + " Muting the music..."
				while volume > 0:
					volume = volume - volumefadespeed
					if volume < 0:
						volume=0
					mixer.music.set_volume(volume);
					time.sleep(0.05)
				if restart:
					mixer.music.stop() #we aren't going to resume the audio, so stop it outright.
				else:
					mixer.music.pause() #we are going to resume, so pause it.
				#print("Muted.  Monitoring emulator.")
				while os.path.exists("/proc/" + pid):
					time.sleep(1); # Delay 1 second and check again.
				#Turn up the music
				#print "Emulator finished, resuming audio..."
				if not restart:
					mixer.music.unpause() #resume
					while volume < maxvolume:
						volume = volume + volumefadespeed;
						if volume > maxvolume:
							volume=maxvolume
						mixer.music.set_volume(volume);
						time.sleep(0.05)
				#print "Music Resumed"
				volume=maxvolume # ensures that the volume is manually set (if restart is True, volume would be at zero)

		except IOError: #proc has already terminated, ignore.
			continue

	time.sleep(1);
	#end of the main while loop

print "An error has occurred that has stopped Test1.py from executing." #theoretically you should never get this far.

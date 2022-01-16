#!/bin/bash

export JOHNY_IMAGE_URI="https://www.apple.com/leadership/images/bio/johny_srouji_image.png.large_2x.png"
export JOHNY_IMAGE_PATH="./images/johny.png"

export LOGO_IMAGE_URI="https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Apple_logo_black.svg/512px-Apple_logo_black.svg.png"
export LOGO_IMAGE_PATH="./images/apple_logo.png"

export SONG_URI="https://www.youtube.com/watch?v=Qa5ule3p68Y"

# we need to check if youtube-dl is available to grab the song
if ! command -v youtube-dl &> /dev/null
then
	echo "youtube-dl is not installed."
	read -p "Do you want to install youtube-dl? (brew install youtube-dl) [y/n] " -n 1 -r
	echo

	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		# check if ffmpeg is installed or INSTALL_FFMPEG is set to 0
		if ! command -v ffmpeg &> /dev/null || [ $INSTALL_FFMPEG -eq 0 ]
		then
			echo "Unless you have something else that works with youtube-dl, you need to install ffmpeg."
			read -p "Install ffmpeg? (brew install ffmpeg) [y/n] " -n 1 -r
			echo

			if [[ $REPLY =~ ^[Yy]$ ]]
			then
				# install ffmpeg
				brew install ffmpeg
			else
				echo "Continuing without ffmpeg."
			fi
		fi

		echo "Installing youtube-dl..."
		brew install youtube-dl
		echo "Installed."
	else
		echo "You need to install youtube-dl to fetch the song."
		exit 1
	fi
fi

# check if the SF Pro fonts are installed
if ! pkgutil --pkg-info com.apple.pkg.SFProFonts &> /dev/null
then
	echo "SF Pro fonts are not installed. They are needed for the project."
	read -p "Do you want to install them? (brew tap homebrew/cask-fonts && brew cask install font-sf-pro) [y/n] " -n 1 -r
	echo

	if [[ $REPLY =~ ^[Yy]$ ]]
	then
		brew tap homebrew/cask-fonts
		brew cask install font-sf-pro
	else
		echo "Continuing without SF Pro fonts."
	fi
fi

echo "Downloading song..."
youtube-dl -x --audio-format mp3 -o "./audio/Samples/%(title)s.%(ext)s" $SONG_URI
echo "Downloaded song."

echo "Downloading Johny image..."
curl $JOHNY_IMAGE_URI -o $JOHNY_IMAGE_PATH
echo "Downloaded."

echo "Downloading logo image..."
curl $LOGO_IMAGE_URI -o $LOGO_IMAGE_PATH
echo "Downloaded."

echo "Done."

echo "----------------------------------------"
echo "Now, you need to open the project found in 'audio' with Ableton Live."
echo "Export the audio file as PCM as 'Maxpod.wav' and save it in the 'audio' folder directly."

echo "Then, open the 'john.motn' project file in Motion and have a field day!"

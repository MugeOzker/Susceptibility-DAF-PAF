# This Praat script processes the raw WAV files and estimates the pitch contour.
#
# Matthias Franken

# Subject identification
form Input
	word subject Subject0
	boolean female 0
endform

# Change parameiters depending on subject gender
if female > 0
	minpitch = 100
	maxpitch = 500
else
	minpitch = 75
	maxpitch = 300
endif

# data directory
datadir$ = "/Users/.../"

# Get list of WAV filenames
session$ = "'subject$'"
Create Strings as file list: "fileList", "'datadir$'/'session$'/*.wav"

# Read in all WAV files
n = Get number of strings
for i to n
	select Strings fileList
	file$ = Get string: i
	Read from file: "'datadir$'/'session$'/'file$'"
	sound'i'= selected("Sound")
endfor

# Acual processing
for i to n
	select sound'i'
	obj_name$ = selected$("Sound")
	
	# Select channel 1 (= subject pitch)
	Extract all channels
	selectObject: "Sound 'obj_name$'"

	# pitch estimateion
	pitch1 = To Pitch (ac): 0.001, minpitch, 15, "no", 0.03, 0.45, 0.01, 0.35, 0.15, maxpitch
	pitch2 = Kill octave jumps
	
	nframes = Get number of frames

	table = Create Table with column names: "table", nframes, "time pitch"

	# Write pitch to table frame by frame
	for j to nframes
		select pitch2
		
		tval = Get time from frame number: j
		f0val = Get value in frame: j, "Hertz"

		if f0val = undefined
			f0val = 0
		endif

		select table

		Set numeric value: j, "time", tval
		Set numeric value: j, "pitch", f0val
	endfor

	# Save table as csv file
	Save as comma-separated file: "'datadir$'/'session$'/'obj_name$'.Table"

	
	# Clean up
	select sound'i'
	plusObject: "Sound 'obj_name$'"
	plus pitch1
	plus pitch2
	plus table
	Remove

	# select channel 2 (= feedback pitch)
	endfor
# packs
library(voice)
library(tidyverse)
library(music)
library(gm)
# set dirs

vaDir <- '~/Downloads/voiceAudios'
wavDir <- paste0(vaDir, '/wav')
mp3Dir <- paste0(vaDir, '/mp3')
rttmDir <- paste0(vaDir, '/rttm')
splitDir <- paste0(vaDir, '/split')
mxmlDir <- paste0(vaDir, '/musicxml')
ifelse(!dir.exists(vaDir), dir.create(vaDir), 'Directory exists!')
ifelse(!dir.exists(wavDir), dir.create(wavDir), 'Directory exists!')
ifelse(!dir.exists(mp3Dir), dir.create(mp3Dir), 'Directory exists!')
ifelse(!dir.exists(rttmDir), dir.create(rttmDir), 'Directory exists!')
ifelse(!dir.exists(splitDir), dir.create(splitDir), 'Directory exists!')
ifelse(!dir.exists(mxmlDir), dir.create(mxmlDir), 'Directory exists!')

# sound files
url0 <- 'https://github.com/filipezabala/voiceAudios/raw/main/wav/bebezinho_2.0005.wav'
download.file(url0, paste0(wavDir, '/bebezinho_2.0005.wav'), mode = 'wb')

# features
ef <- voice::extract_features(wavDir, features = c('f0','formants','gain'),
                              round.to = 6, windowShift = 5)
ef

# pooling
(ef01 <- voice::conv_df(ef, .01)) # 1%

# assign notes
spn <- lapply(ef01[2:10], voice::notes)
spn <- bind_rows(spn)
colnames(spn) <- paste0('spn_', colnames(spn))
ef01 <- bind_cols(ef01, spn)

midi <- lapply(ef01[2:10], voice::notes, method = 'midi')
midi <- bind_rows(midi)
colnames(midi) <- paste0('midi_', colnames(midi))
ef01 <- bind_cols(ef01, midi)
glimpse(ef01)


# Distance (in semitones)
nd.spn <- music::noteDistance(as.character(ef01$spn_F0))
table(nd.spn) # semitones

# Get duration
dur.spn <- voice::duration(ef01$spn_F0)
dur.midi <- voice::duration(ef01$midi_F0)

# play
music::playNote(note = as.character(dur.spn$note),
                duration = dur.spn$dur_line)

# Partiture
m <- gm::Music()
m <- m +
  # add a 4/4 time signature
  gm::Meter(4, 4) +
  # manually adding midi notes
  gm::Line(pitches = list(51, 53, 61, 58),
           durations = list(1,1,1,1))
m
#> Meter 4/4
export(m, mxmlDir, 'bebezinho', 'musicxml', '-r 200 -b 520')


# cut audios
# font url
url0 <- 'https://github.com/filipezabala/voiceAudios/raw/main/mp3/'

# mp3 files
mp3Files <- c('anthem0.mp3', 'anthem1.mp3', 'anthem2.mp3',
              'game0.mp3', 'game1.mp3', 'game2.mp3',
              'phantom0.mp3', 'phantom1.mp3',  'phantom2.mp3',
              'romeo0.mp3', 'romeo1.mp3', 'romeo2.mp3',
              'sherlock0.mp3', 'sherlock1.mp3', 'sherlock2.mp3',
              'war0.mp3', 'war1.mp3', 'war2.mp3')

# downloading mp3 files
for(i in mp3Files){
  system(paste0('wget -r -np -k ', url0, i, ' -P ~/Downloads/voiceAudios/mp3'))
}

# tidying up files and directories
system('cp ~/Downloads/voiceAudios/mp3/github.com/filipezabala/voiceAudios/raw/main/mp3/*.* ~/Downloads/voiceAudios/mp3')
system('rm -rf ~/Downloads/voiceAudios/mp3/github.com/')

# converting mp3 to wav
cmd3 <- 'cd ~/Downloads/voiceAudios/mp3;
for i in *.[Mm][Pp]3; do ffmpeg -i "$i" "../wav/${i%.*}.wav"; done'
system(cmd3)
wavFiles <- dir(wavDir, pattern = '[Ww][Aa][Vv]', full.names = T)

# (who) speaks when?
ini <- Sys.time()
voice::wsw(wavDir, to = rttmDir, pycall = '~/miniconda3/envs/pyvoice38/bin/python3.8')
Sys.time()-ini # Time difference of 11.34808 mins

const playAudio = (path) => {
  const audioPlayer = new Audio(path);
  audioPlayer.play();
}

export {
  playAudio
};
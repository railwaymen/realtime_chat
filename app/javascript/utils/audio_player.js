const playAudio = (path) => {
  const audio = new Audio(path);
  audio.addEventListener('canplaythrough', audio.play , false);
}

export {
  playAudio
};
const playAudio = async (path) => {
  const audio = new Audio(path);
  await audio.load();

  audio.addEventListener('canplaythrough', audio.play, false);
};

export default playAudio;

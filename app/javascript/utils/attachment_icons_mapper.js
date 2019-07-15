const attachmentIconsMapper = (extension) => {
  switch (extension) {
    case 'mp3':
    case 'wav':
      return 'mp3';
    case 'mp4':
    case 'avi':
    case 'mov':
      return 'avi-mp4';
    case 'rb':
      return 'ruby';
    case 'py':
      return 'python'
    case 'js':
      return 'javascript';
    case 'sql':
      return 'sql';
    case 'zip':
    case 'rar':
      return 'zip';
    case 'pdf':
      return 'pdf';
    case 'doc':
    case 'docx':
      return 'word';
    case 'xls':
    case 'xlsx':
      return 'excel'
    default:
      return 'file'
  };
};

export default attachmentIconsMapper;
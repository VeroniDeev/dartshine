class FolderError extends Error{
  final String folder;
  
  FolderError({required this.folder});

  @override
  String toString() {
    return 'Folder $folder: already exists';
  }
}
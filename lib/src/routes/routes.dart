class DartshineRoute{
  List<Map<String, dynamic>> urls = [];

  Map<String, dynamic> findUrl(String reqPath){
    for(Map<String, dynamic> path in urls){
      if(path['path'] == reqPath){
        return path;
      }
    }
    return {};
  }
}
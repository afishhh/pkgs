{
  jakt = builtins.fetchTree {
    type = "github";
    owner = "SerenityOS";
    repo = "jakt";
    rev = "8f5681207630919e5b90b50657bd71eb8f2db117";
  };
  serenity = builtins.fetchTree {
    type = "github";
    owner = "SerenityOS";
    repo = "serenity";
    rev = "26555baf53fd89622c564d3e87582088a3fb09e8";
  };
}

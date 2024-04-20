{
  jakt = builtins.fetchTree {
    type = "github";
    owner = "SerenityOS";
    repo = "jakt";
    rev = "6ac969f04325d3b48fd11acca73d0ce6da31e851";
  };
  serenity = builtins.fetchTree {
    type = "github";
    owner = "SerenityOS";
    repo = "serenity";
    rev = "9540af64893e3196613feb3a77a9cbc92209c2f9";
  };
}

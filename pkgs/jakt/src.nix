{
  jakt = builtins.fetchTree {
    type = "github";
    owner = "SerenityOS";
    repo = "jakt";
    rev = "d65f014cc54b986f629fe676d914af01d442b9f7";
  };
  serenity = builtins.fetchTree {
    type = "github";
    owner = "SerenityOS";
    repo = "serenity";
    rev = "f23a1c6e9791284d2af025e126bcca48310a16c3";
  };
}

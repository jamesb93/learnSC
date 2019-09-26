//// Interact with some JSON business ////
Array

(
~json_data = File.readAllString("/Users/jamesbradbury/learnSC/json_dummy.json").parseYAML;
)

// Referenace a single parent node in the json //
(
~json_data["94"];
)

// Iterate over a whole cluster //
(
~json_data["5"].do(
    {
        arg item, i;
        [i, item].postln;
    }
)
)

(
~json_data["5"].size;
)


//// ---------------------------------------------------------------- ////
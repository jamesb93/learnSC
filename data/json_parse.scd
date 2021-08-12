//// Interact with some JSON business ////

(
~json_data = File.readAllString("/Users/james/dev/learnSC/json_dummy.json").parseYAML;
)

// Reference a single parent node in the json //
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

// Query the  number of pairs associated to a key //
(
~json_data["5"].size;
)


//// ---------------------------------------------------------------- ////
var FeatureToggles = require("@sap/hana-tooling-feature-toggles");
console.log(__dirname);
const FeatureToggleInstance = new FeatureToggles(__dirname + "/features.json");
console.log(FeatureToggleInstance);
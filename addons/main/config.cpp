#include "script_component.hpp"

// information on this addon specifically
class CfgPatches {
    class ADDON {
        name = COMPONENT_NAME;
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"cba_main"}; // include external addons here that your whole mod depends on and have your other addons require this one.
        authors[] = {"Ampersand"}; // sub array of authors, considered for the specific addon
        author = "Ampersand"; // primary author name, either yours or your team's, considered for the whole mod
        VERSION_CONFIG;
    };
};

// information on the whole mod (only needed once)
class CfgMods {
    class PREFIX {
        dir = "@AHDNC";
        name = "AI Helicopter Decelerate No Climbing";
        
        author = "Ampersand";                    // probably shown somewhere in the mods menu, but probably ignored by CBA/HEMTT

        picture         = "logo_ampersand_ca.paa";       // Picture displayed from the expansions menu. Optimal size is 2048x1024
        hideName        = "false";              // Hide the extension name in main menu and extension menu
        hidePicture     = "false";              // Hide the extension picture in the extension menu

        action          = "https://github.com/ampersand38/ai-heli-decel-no-climb"; // Website URL, that can accessed from the expansions menu 
        actionName      = "GitHub";              // label of button/tooltip in extension menu
        description     = "AI Helicopter Decelerate No Climbing"; // Probably in context with action

        // Color used for DLC stripes and backgrounds (RGBA)
        dlcColor[] = {1, 0.0, 0.86, 1};
    };
};
// Configs go here

#include "CfgEventHandlers.hpp"
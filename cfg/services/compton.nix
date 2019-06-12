{...}:

{
  services.compton = {
    enable = true;

    fade = true;
    fadeDelta = 4;
    fadeSteps = [ "0.03" "0.03" ];
    

    activeOpacity = "0.9";
    inactiveOpacity = "0.9";

    extraOptions = ''
      inactive-dim = 0.2;
    '';
  };
}

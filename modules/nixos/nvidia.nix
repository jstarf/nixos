{ pkgs, config, libs, ... }:
{
  # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];
    #services.xserver.videoDrivers = ["nvidia-dkms"];

    hardware.nvidia = {

        # Modesetting is required.
        modesetting.enable = true;

        powerManagement = {
                # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
                enable = false; # must be false if prime's sync mode is used

                # Fine-grained power management. Turns off GPU when not in use.
                # Experimental and only works on modern Nvidia GPUs (Turing or newer).
                #finegrained = true;
        };

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at:
        # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
        # Only available from driver 515.43.04+
        # Currently alpha-quality/buggy, so false is currently the recommended setting.
        open = false;

        # Optionally, you may need to select the appropriate driver version for your specific GPU.
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        prime = {
            # Optimus PRIME Option A: Offload Mode
                    #offload = {
                    #   enable = true;
                #       enableOffloadCmd = true;
                #};

            # Optimus PRIME Option B: Sync Mode
            sync.enable = true;

            # lshw -c display
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
        };

        # Enable the Nvidia settings menu,
            # accessible via `nvidia-settings`.
        nvidiaSettings = true;

    };

    hardware.opengl = {
        extraPackages = with pkgs; [nvidia-vaapi-driver intel-media-driver];
        extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver intel-media-driver];

        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };

}

![Alttext](https://github.com/Dimserene/Fine-tuned-Pack/blob/main/Real_Fine_Tuned_Logo.png)
Contains every mods in [Vanilla Plus Pack](https://github.com/Dimserene/Vanilla-Plus-Pack)

Main modpack: [Dimserene's Modpack](https://github.com/Dimserene/Dimserenes-Modpack)

Mod List: [Google Sheet](https://docs.google.com/spreadsheets/d/1L2wPG5mNI-ZBSW_ta__L9EcfAw-arKrXXVD-43eU4og/)


## Prerequisites

- Install [Git](https://git-scm.com/)

  [Download](https://git-scm.com/downloads)

- Install [__Lovely__](https://github.com/ethangreen-dev/lovely-injector) (latest release)

    [Download](https://github.com/ethangreen-dev/lovely-injector/releases) [Discord](https://discord.com/channels/1116389027176787968/1214591552903716954) [Authors](https://github.com/ethangreen-dev/lovely-injector/graphs/contributors?from=2024-03-03&to=2024-06-26&type=c)


## How to Install

  (Windows) Download the __SetupFineTuned.bat__ and put it wherever you want, and run it. The mods will be automatically downloaded and put into correct directory.

  Or

  Run following scripts in command prompt:

  ```
  git clone --recurse-submodules --remote-submodules https://github.com/Dimserene/Fine-tuned-Pack
  ```

  And then copy all the contents in Mods folder to your Mods folder.

## How to Update Modpack

  (Windows) Run __UpdateFineTuned.bat__ which should be in the downloaded Fine-tuned-Pack folder.

  Or

  Run following scripts in command prompt:

  ```
git remote set-url origin https://github.com/Dimserene/Fine-tuned-Pack
git pull
git submodule update --remote --recursive --merge
  ```

  And then, again, copy all the contents in Mods folder to your Mods folder.

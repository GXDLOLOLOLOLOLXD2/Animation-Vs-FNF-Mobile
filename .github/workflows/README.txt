--- Based in "withAddictions.yml" file:

Default libraries:
      - name: Install Haxelibs
        run: |
          haxelib setup ~/haxelib
          haxelib install hxcpp --quiet
          haxelib install lime 8.2.2 --quiet
          haxelib install openfl 9.4.1 --quiet
          haxelib install flixel 5.6.1 --quiet
          haxelib install flixel-addons 3.1.1 --quiet
          haxelib install flixel-ui 2.6.1 --quiet
          haxelib install flixel-tools --quiet
          haxelib install actuate --quiet
          haxelib install hscript --quiet
          haxelib install hxCodec --quiet
          haxelib git extension-webview https://github.com/Daninnocent/extension-webview.git --quiet
          haxelib git extension-androidtools https://github.com/MAJigsaw77/extension-androidtools.git --quiet
          haxelib git linc_luajit https://github.com/MaysLastPlays-Stuff/linc_luajit.git --quiet
          haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc.git --quiet
          haxelib list
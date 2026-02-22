![ci](https://github.com/bndw/len.to/workflows/ci/badge.svg)

# len.to

My personal photo blog.

<br>
<img src="https://user-images.githubusercontent.com/4248167/127943051-a5803622-3af5-4125-a726-1d6c92b48103.png">
<br>

### Quickstart

Run the latest Docker image on http://localhost:8080

```
make run
```

Build the Docker image

```
make build
```

Run the live-reload server on http://localhost:1313

```
make dev
```

### License

The code for this site is licensed under [GNU AGPLv3](https://choosealicense.com/licenses/agpl-3.0/). The content for this site is licensed under [Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International](https://creativecommons.org/licenses/by-nc-nd/4.0/).



Per convertire i file .heic, apri Powershell, vai nella cartella, ad esempio:
cd C:\Users\matte\Downloads\drive-download-20260210T203507Z-1-001

poi scrivi

Get-ChildItem *.heic | ForEach-Object { magick $_.Name "$($_.BaseName).jpg" }





Per provare il sito su locale prima apri PowerShell e scrivi:
hugo server

Puoi provare il sito su http://localhost:1313


Quando sei soddisfatto:
hugo
(genera la cartella public/)

Copia tutto il contenuto della cartella public e pubblicalo su github pages

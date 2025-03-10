function(composeDesktopFile)

    set(fname "org.photoqt.PhotoQt.desktop")
    set(suffix "")

    file(WRITE  "${fname}" "[Desktop Entry]\n")
    file(APPEND "${fname}" "Name=PhotoQt${suffix}\n")
    file(APPEND "${fname}" "Name[ca]=PhotoQt${suffix}\n")
    file(APPEND "${fname}" "Name[cs]=PhotoQt${suffix}\n")
    file(APPEND "${fname}" "Name[de]=PhotoQt${suffix}\n")
    file(APPEND "${fname}" "Name[es]=PhotoQt${suffix}\n")
    file(APPEND "${fname}" "Name[fr]=PhotoQt${suffix}\n")
    file(APPEND "${fname}" "Name[nl]=PhotoQt${suffix}\n")
    file(APPEND "${fname}" "Name[sr]=ФотоQт${suffix}\n")
    file(APPEND "${fname}" "Name[sr@ijekavian]=ФотоQт${suffix}\n")
    file(APPEND "${fname}" "Name[sr@ijekavianlatin]=FotoQt${suffix}\n")
    file(APPEND "${fname}" "Name[sr@latin]=FotoQt${suffix}\n")
    file(APPEND "${fname}" "GenericName=Image Viewer${suffix}\n")
    file(APPEND "${fname}" "GenericName[ca]=Visor d'imatges${suffix}\n")
    file(APPEND "${fname}" "GenericName[cs]=Prohlížeč obrázků${suffix}\n")
    file(APPEND "${fname}" "GenericName[de]=Bildbetrachter${suffix}\n")
    file(APPEND "${fname}" "GenericName[es]=Visor de imagenes${suffix}\n")
    file(APPEND "${fname}" "GenericName[fr]=Visualisateur d'images${suffix}\n")
    file(APPEND "${fname}" "GenericName[nl]=Afbeeldingen-viewer${suffix}\n")
    file(APPEND "${fname}" "GenericName[sr]=Приказивач слика${suffix}\n")
    file(APPEND "${fname}" "GenericName[sr@ijekavian]=Приказивач слика${suffix}\n")
    file(APPEND "${fname}" "GenericName[sr@ijekavianlatin]=Prikazivač slika${suffix}\n")
    file(APPEND "${fname}" "GenericName[sr@latin]=Prikazivač slika${suffix}\n")
    file(APPEND "${fname}" "Comment=View and manage images${suffix}\n")
    file(APPEND "${fname}" "Comment[ca]=Visualitza i gestiona imatges${suffix}\n")
    file(APPEND "${fname}" "Comment[cs]=Prohlížet and spravovat obrázky${suffix}\n")
    file(APPEND "${fname}" "Comment[de]=Betrachte und manage Bilder${suffix}\n")
    file(APPEND "${fname}" "Comment[es]=Visualizar y gestionar imágenes${suffix}\n")
    file(APPEND "${fname}" "Comment[fr]=Voir et gérer des images${suffix}\n")
    file(APPEND "${fname}" "Comment[nl]=Bekijk en beheer afbeeldingen${suffix}\n")
    file(APPEND "${fname}" "Comment[sr]=Приказује и управља сликама${suffix}\n")
    file(APPEND "${fname}" "Comment[sr@ijekavian]=Приказује и управља сликама${suffix}\n")
    file(APPEND "${fname}" "Comment[sr@ijekavianlatin]=Prikazuje i upravlja slikama${suffix}\n")
    file(APPEND "${fname}" "Comment[sr@latin]=Prikazuje i upravlja slikama${suffix}\n")
    file(APPEND "${fname}" "Exec=photoqt %f\n")
    file(APPEND "${fname}" "Icon=org.photoqt.PhotoQt\n")
    file(APPEND "${fname}" "Type=Application\n")
    file(APPEND "${fname}" "Terminal=false\n")
    file(APPEND "${fname}" "Categories=Graphics;Viewer;\n")

    # add the mimetypes
    set(MIMETYPE "application/x-navi-animation;video/x-ms-asf;application/vnd.ms-asf;image/avif;image/avif-sequence;")
    set(MIMETYPE "${MIMETYPE}application/x-fpt;image/bmp;image/x-ms-bmp;image/bpg;image/x-canon-crw;")
    set(MIMETYPE "${MIMETYPE}image/x-canon-cr2;image/x-win-bitmap;application/dicom;image/dicom-rle;image/vnd.djvu;")
    set(MIMETYPE "${MIMETYPE}image/x-dpx;image/x-exr;image/fits;image/gif;image/heic;")
    set(MIMETYPE "${MIMETYPE}image/heif;image/vnd.microsoft.icon;image/x-icon;image/x-icns;application/x-pnf;video/x-jng;")
    set(MIMETYPE "${MIMETYPE}image/jpeg;image/jp2;image/jpx;image/jpm;image/jxl;")
    set(MIMETYPE "${MIMETYPE}application/x-krita;image/x-miff;video/x-mng;image/x-mvg;image/openraster;")
    set(MIMETYPE "${MIMETYPE}image/x-olympus-orf;font/opentype;application/vnd.ms-opentype;image/x-portable-arbitrarymap;image/x-portable-pixmap;")
    set(MIMETYPE "${MIMETYPE}image/x-portable-anymap;image/vnd.zbrush.pcx;image/x-pcx;image/x-pentax-pef;image/x-portable-greymap;")
    set(MIMETYPE "${MIMETYPE}image/x-xpmi;image/png;image/vnd.adobe.photoshop;image/tiff;image/sgi;")
    set(MIMETYPE "${MIMETYPE}image/svg+xml;image/x-targa;image/x-tga;image/tiff-fx;font/sfnt;")
    set(MIMETYPE "${MIMETYPE}image/vnd.wap.wbmp;image/webp;image/x-xbitmap;image/x-xbm;image/x-xcf;")
    set(MIMETYPE "${MIMETYPE}image/x-xpixmap;")

    file(APPEND "${fname}" "MimeType=${MIMETYPE}")

endfunction()


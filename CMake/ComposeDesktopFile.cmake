function(composeDesktopFile)

    set(versions 0;1)

    foreach(version IN LISTS versions)

        if(${version} EQUAL 0)
            set(fname "org.photoqt.PhotoQt.desktop")
            set(suffix "")
        else()
            set(fname "org.photoqt.PhotoQt.standalone.desktop")
            set(suffix " (standalone)")
        endif()

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
        if(${version} EQUAL 0)
            file(APPEND "${fname}" "Exec=photoqt %f\n")
        else()
            file(APPEND "${fname}" "Exec=photoqt --standalone %f\n")
        endif()
        file(APPEND "${fname}" "Icon=photoqt\n")
        file(APPEND "${fname}" "Type=Application\n")
        file(APPEND "${fname}" "Terminal=false\n")
        file(APPEND "${fname}" "Categories=Graphics;Viewer;\n")

        # add the mimetypes
        set(MIMETYPE "application/x-navi-animation;image/avif;image/avif-sequence;application/x-fpt;image/bmp;")
        set(MIMETYPE "${MIMETYPE}image/x-ms-bmp;image/bpg;image/x-canon-crw;image/x-canon-cr2;image/x-win-bitmap;")
        set(MIMETYPE "${MIMETYPE}application/dicom;image/dicom-rle;image/vnd.djvu;image/x-dpx;application/postscript;")
        set(MIMETYPE "${MIMETYPE}application/eps;application/x-eps;image/eps;image/x-eps;image/x-exr;")
        set(MIMETYPE "${MIMETYPE}image/fits;image/gif;image/heic;image/heif;image/vnd.microsoft.icon;")
        set(MIMETYPE "${MIMETYPE}image/x-icon;application/x-pnf;video/x-jng;image/jpeg;image/jp2;")
        set(MIMETYPE "${MIMETYPE}image/jpx;image/jpm;image/jxl;application/x-krita;image/x-miff;")
        set(MIMETYPE "${MIMETYPE}video/x-mng;image/x-mvg;image/openraster;image/x-olympus-orf;font/opentype;")
        set(MIMETYPE "${MIMETYPE}application/vnd.ms-opentype;image/x-portable-arbitrarymap;image/x-portable-pixmap;image/x-portable-anymap;image/vnd.zbrush.pcx;")
        set(MIMETYPE "${MIMETYPE}image/x-pcx;application/pdf;application/x-pdf;application/x-bzpdf;application/x-gzpdf;")
        set(MIMETYPE "${MIMETYPE}image/x-pentax-pef;image/x-portable-greymap;image/x-xpmi;image/png;image/vnd.adobe.photoshop;")
        set(MIMETYPE "${MIMETYPE}image/tiff;image/sgi;image/svg+xml;image/x-targa;image/x-tga;")
        set(MIMETYPE "${MIMETYPE}image/tiff-fx;font/sfnt;image/vnd.wap.wbmp;image/webp;image/x-xbitmap;")
        set(MIMETYPE "${MIMETYPE}image/x-xbm;image/x-xcf;image/x-xpixmap;")

        file(APPEND "${fname}" "MimeType=${MIMETYPE}")

    endforeach()

endfunction()


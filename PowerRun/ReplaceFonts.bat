@echo off

echo Checking font updates...
echo.

rem Uses %SystemDrive% in case the OS/Users folder isn't on C:
set "TARGET_USER=Kevin"
set "DOWNLOAD_DIR=%SystemDrive%\Users\%TARGET_USER%\Downloads"
set "FONT_DIR=%SystemRoot%\Fonts"

rem List of fonts to process
for %%F in (msyh.ttc msyhl.ttc msyhbd.ttc simsun.ttc simsunb.ttf simhei.ttf) do (
    if exist "%DOWNLOAD_DIR%\%%F" (
        echo Processing %%F...
        
        rem 1. Handle Backups and Moving the Active Font
        if not exist "%FONT_DIR%\%%F.bak" (
            if exist "%FONT_DIR%\%%F" (
                echo Creating permanent original backup for %%F...
                rem Move directly to .bak since it doesn't exist yet
                move "%FONT_DIR%\%%F" "%FONT_DIR%\%%F.bak" >nul
            )
        ) else (
            echo Original backup for %%F already exists. Keeping it safe.
            if exist "%FONT_DIR%\%%F" (
                rem Move to .000 only if .bak already exists
                move "%FONT_DIR%\%%F" "%FONT_DIR%\%%F.000" >nul
            )
        )
        
        rem 2. Copy the new font into the folder
        copy /Y "%DOWNLOAD_DIR%\%%F" "%FONT_DIR%\%%F" >nul
        
        rem 3. Clean up the source file from Downloads
        del "%DOWNLOAD_DIR%\%%F" /Q >nul
        
        rem 4. Clean up the temporary .000 file if it was created
        if exist "%FONT_DIR%\%%F.000" (
            del "%FONT_DIR%\%%F.000" /Q >nul
        )
        
        echo %%F updated successfully.
    ) else (
        echo Skipping %%F - not found in Downloads.
    )
    echo ---------------------------------------
)

pause
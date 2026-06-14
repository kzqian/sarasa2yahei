@echo off
set "TARGET_USER=Kevin"
set "DOWNLOAD_DIR=%SystemDrive%\Users\%TARGET_USER%\Downloads"
set "FONT_DIR=%SystemRoot%\Fonts"

:menu
cls
echo ===========================================
echo       WINDOWS SYSTEM FONT MANAGER          
echo ===========================================
echo  Target User: %TARGET_USER%
echo ===========================================
echo.
echo  [1] Update / Replace Fonts (From Downloads)
echo  [2] Restore Default Fonts (From .bak)
echo  [3] Exit
echo.
echo ===========================================

choice /c 123 /n /m "Please select an option (1-3): "

if errorlevel 3 goto end
if errorlevel 2 goto restore_fonts
if errorlevel 1 goto update_fonts
goto menu

:update_fonts
cls
echo Checking font updates...
echo ---------------------------------------
for %%F in (msyh.ttc msyhl.ttc msyhbd.ttc simsun.ttc simsunb.ttf simhei.ttf) do (
    if exist "%DOWNLOAD_DIR%\%%F" (
        echo Processing %%F...
        
        rem 1. Handle Backups and Moving the Active Font
        if not exist "%FONT_DIR%\%%F.bak" (
            if exist "%FONT_DIR%\%%F" (
                echo Creating permanent original backup for %%F...
                move "%FONT_DIR%\%%F" "%FONT_DIR%\%%F.bak" >nul
            )
        ) else (
            echo Original backup for %%F already exists. Keeping it safe.
            if exist "%FONT_DIR%\%%F" (
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
echo.
echo Operation complete.
timeout /t 10
goto menu

:restore_fonts
cls
echo Restoring original fonts from backups...
echo ---------------------------------------
for %%F in (msyh.ttc msyhl.ttc msyhbd.ttc simsun.ttc simsunb.ttf simhei.ttf) do (
    rem Check if the original backup (.bak) exists
    if exist "%FONT_DIR%\%%F.bak" (
        echo Restoring %%F from backup...
        
        rem 1. Move the current modified font to .000 to clear the slot
        if exist "%FONT_DIR%\%%F" (
            move "%FONT_DIR%\%%F" "%FONT_DIR%\%%F.000" >nul
        )
        
        rem 2. Move the permanent .bak file back to the active font name
        move "%FONT_DIR%\%%F.bak" "%FONT_DIR%\%%F" >nul
        
        rem 3. Clean up the temporary .000 file
        if exist "%FONT_DIR%\%%F.000" (
            del "%FONT_DIR%\%%F.000" /Q >nul
        )
        
        echo %%F successfully restored to original.
    ) else (
        echo Skipping %%F - No original backup .bak found.
    )
    echo ---------------------------------------
)
echo.
echo Operation complete.
timeout /t 10
goto menu

:end
echo Goodbye!
timeout /t 1 >nul
exit
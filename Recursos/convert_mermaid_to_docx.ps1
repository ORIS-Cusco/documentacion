# Script: convert_mermaid_to_docx.ps1
# Convierte METODOLOGIA_ORIS.md a .docx con diagramas Mermaid renderizados como PNG

$InputMd = "METODOLOGIA_ORIS.md"
$OutputMd = "METODOLOGIA_ORIS_rendered.md"
$OutputDocx = "METODOLOGIA_ORIS.docx"
$ImgDir = "mermaid_imgs"

# 1. Crear directorio de imagenes
if (Test-Path $ImgDir) { Remove-Item $ImgDir -Recurse -Force }
New-Item -ItemType Directory -Path $ImgDir | Out-Null
Write-Host "Directorio de imagenes creado: $ImgDir"

# 2. Leer el archivo MD
$lines = Get-Content $InputMd -Encoding UTF8
$output = [System.Collections.Generic.List[string]]::new()
$inMermaid = $false
$mermaidBlock = [System.Collections.Generic.List[string]]::new()
$imgCounter = 0

foreach ($line in $lines) {
    if ($line.Trim() -eq '```mermaid') {
        $inMermaid = $true
        $mermaidBlock = [System.Collections.Generic.List[string]]::new()
        continue
    }

    if ($inMermaid -and $line.Trim() -eq '```') {
        $inMermaid = $false
        $imgCounter++
        $mmdFile = Join-Path $ImgDir "diagram_$imgCounter.mmd"
        $pngFile = Join-Path $ImgDir "diagram_$imgCounter.png"

        # Guardar bloque mermaid como .mmd
        [System.IO.File]::WriteAllText((Resolve-Path ".").Path + "\$mmdFile", ($mermaidBlock -join "`n"), [System.Text.Encoding]::UTF8)

        # Renderizar con npx mmdc
        Write-Host "Renderizando diagrama $imgCounter..."
        $args_list = @("--yes", "@mermaid-js/mermaid-cli", "mmdc", "-i", $mmdFile, "-o", $pngFile, "-b", "white", "-w", "1200", "--scale", "2")
        $proc = Start-Process "npx" -ArgumentList $args_list -Wait -PassThru -NoNewWindow -RedirectStandardError "err_$imgCounter.txt"

        if (Test-Path $pngFile) {
            Write-Host "  OK Diagrama $imgCounter generado: $pngFile"
            $absPath = (Resolve-Path $pngFile).Path
            $output.Add("![$imgCounter]($absPath)")
        }
        else {
            Write-Host "  ERROR en diagrama $imgCounter - se insertara como texto"
            $output.Add('```')
            foreach ($ml in $mermaidBlock) { $output.Add($ml) }
            $output.Add('```')
        }
        $mermaidBlock = [System.Collections.Generic.List[string]]::new()
        continue
    }

    if ($inMermaid) {
        $mermaidBlock.Add($line)
    }
    else {
        $output.Add($line)
    }
}

# 3. Guardar MD procesado
[System.IO.File]::WriteAllText((Resolve-Path ".").Path + "\$OutputMd", ($output -join "`n"), [System.Text.Encoding]::UTF8)
Write-Host ""
Write-Host "Markdown renderizado guardado: $OutputMd"

# 4. Convertir a DOCX con pandoc
Write-Host "Convirtiendo a Word con pandoc..."
$pandocArgs = @($OutputMd, "-o", $OutputDocx, "--from", "markdown", "--to", "docx", "-s")
$pandocProc = Start-Process "pandoc" -ArgumentList $pandocArgs -Wait -PassThru -NoNewWindow
if (Test-Path $OutputDocx) {
    $size = [math]::Round((Get-Item $OutputDocx).Length / 1KB, 1)
    Write-Host ""
    Write-Host "LISTO: $OutputDocx generado ($size KB)"
}
else {
    Write-Host "Error al generar el .docx"
}

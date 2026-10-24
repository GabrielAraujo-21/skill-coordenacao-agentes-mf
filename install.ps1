<#
.SYNOPSIS
  Instala a skill coordenacao-agentes em .claude\skills\ de um projeto.

.EXAMPLE
  .\install.ps1 -Projeto C:\meu-projeto -ComDocumentos

.PARAMETER Projeto
  Raiz do projeto (padrão: pasta atual).
.PARAMETER ComDocumentos
  Também cria COORDENACAO-AGENTES.md e PENDENCIAS.md na raiz (se não existirem)
  e insere a regra no AGENTS.md/CLAUDE.md.
.PARAMETER Prefixo
  Prefixo dos IDs das pendências (padrão: P).
.PARAMETER Forcar
  Substitui uma instalação anterior da skill.
#>
param(
    [string]$Projeto = ".",
    [switch]$ComDocumentos,
    [string]$Prefixo = "P",
    [switch]$Forcar
)
$ErrorActionPreference = "Stop"

$RepoUrl = "https://github.com/GabrielAraujo-21/skill-coordenacao-agentes-mf.git"
$Nome = "coordenacao-agentes"
$Utf8 = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path $Projeto -PathType Container)) { throw "Pasta não encontrada: $Projeto" }
$Projeto = (Resolve-Path $Projeto).Path

# Origem: a cópia ao lado deste script ou um clone temporário.
$tmp = $null
$origem = if ($PSScriptRoot) { Join-Path $PSScriptRoot "plugins\$Nome\skills\$Nome" } else { "" }
if (-not $origem -or -not (Test-Path (Join-Path $origem "SKILL.md"))) {
    $tmp = Join-Path ([IO.Path]::GetTempPath()) ([guid]::NewGuid())
    git clone --depth 1 --quiet $RepoUrl "$tmp\repo"
    if ($LASTEXITCODE -ne 0) { throw "Falha ao clonar $RepoUrl" }
    $origem = "$tmp\repo\plugins\$Nome\skills\$Nome"
}

try {
    $destino = Join-Path $Projeto ".claude\skills\$Nome"
    if ((Test-Path $destino) -and -not $Forcar) {
        Write-Host "A skill já está instalada em $destino (use -Forcar para substituir)."
    } else {
        if (Test-Path $destino) { Remove-Item $destino -Recurse -Force }
        New-Item -ItemType Directory -Force (Split-Path $destino) | Out-Null
        Copy-Item $origem $destino -Recurse
        Write-Host "Skill instalada em $destino"
    }

    if ($ComDocumentos) {
        $hoje = Get-Date -Format "yyyy-MM-dd"
        foreach ($doc in "COORDENACAO-AGENTES.md", "PENDENCIAS.md") {
            $alvo = Join-Path $Projeto $doc
            if (Test-Path $alvo) {
                Write-Host "$doc já existe; mantido."
            } else {
                $texto = [IO.File]::ReadAllText((Join-Path $origem "modelos\$doc"), $Utf8)
                $texto = $texto.Replace("{{DATA}}", $hoje).Replace("{{PREFIXO}}", $Prefixo)
                [IO.File]::WriteAllText($alvo, $texto, $Utf8)
                Write-Host "$doc criado."
            }
        }

        $agents = Join-Path $Projeto "AGENTS.md"
        $claude = Join-Path $Projeto "CLAUDE.md"
        if (Test-Path $agents) { $regras = $agents }
        elseif (Test-Path $claude) { $regras = $claude }
        else {
            $regras = $agents
            [IO.File]::WriteAllText($agents, "# AGENTS.md`n", $Utf8)
            [IO.File]::WriteAllText($claude, "@AGENTS.md`n", $Utf8)
            Write-Host "AGENTS.md e CLAUDE.md criados."
        }
        $atual = [IO.File]::ReadAllText($regras, $Utf8)
        if ($atual.Contains("coordenacao-agentes:inicio")) {
            Write-Host "$(Split-Path $regras -Leaf) já tem a regra de coordenação; mantido."
        } else {
            $trecho = [IO.File]::ReadAllText((Join-Path $origem "modelos\trecho-regra.md"), $Utf8)
            [IO.File]::AppendAllText($regras, "`n" + $trecho, $Utf8)
            Write-Host "Regra de coordenação acrescentada ao $(Split-Path $regras -Leaf)."
        }
    }

    Write-Host ""
    Write-Host 'Pronto. Abra o projeto no Claude Code e peça: "use a skill coordenacao-agentes para iniciar a coordenação".'
} finally {
    if ($tmp -and (Test-Path $tmp)) { Remove-Item $tmp -Recurse -Force }
}

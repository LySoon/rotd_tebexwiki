# Publishes the local wiki folder to BOTH the GitHub wiki and the GitHub Pages site.
# Usage: .\sync.ps1 "commit message"
param([string]$Message = "Update wiki")

$src   = "C:\Users\emirm\OneDrive\Masa$([char]0xFC)st$([char]0xFC)\codework\rotd\wiki"
$work  = Join-Path $env:TEMP "rotd_sync"
$repos = @(
  @{ Name = "site"; Url = "https://github.com/LySoon/rotd_tebexwiki.git" },
  @{ Name = "wiki"; Url = "https://github.com/LySoon/rotd_tebexwiki.wiki.git" }
)

if (Test-Path $work) { Remove-Item -Recurse -Force $work }
New-Item -ItemType Directory $work | Out-Null

foreach ($r in $repos) {
  $dir = Join-Path $work $r.Name
  git clone -q $r.Url $dir
  # use your own git identity if set, otherwise a repo-local fallback so the commit never fails
  if (-not (git -C $dir config user.email)) {
    git -C $dir config user.name "LySoon"
    git -C $dir config user.email "emirmutlu20@windowslive.com"
  }
  Copy-Item "$src\*.md" $dir -Force
  if ($r.Name -eq 'site') {
    (Get-Content "$src\_Sidebar.md" -Raw) -replace '\[\[([^\]]+)\]\]','[$1]($1)' | Set-Content "$dir\_docsify_sidebar.md" -Encoding utf8
  }
  git -C $dir add -A
  if (git -C $dir status --porcelain) {
    git -C $dir commit -q -m $Message
    if ($LASTEXITCODE -ne 0) { Write-Host "$($r.Name): commit FAILED"; continue }
    git -C $dir push -q origin HEAD
    if ($LASTEXITCODE -ne 0) { Write-Host "$($r.Name): push FAILED"; continue }
    Write-Host "$($r.Name): pushed"
  } else {
    Write-Host "$($r.Name): no changes"
  }
}
Remove-Item -Recurse -Force $work


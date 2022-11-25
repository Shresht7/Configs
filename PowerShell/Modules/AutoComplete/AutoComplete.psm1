# ============
# AutoComplete
# ============

# GitHub CLI
Invoke-Expression -Command $(gh completion -s powershell | Out-String)

# Deno
Invoke-Expression (deno completions powershell | Out-String)

# NPM
Register-ArgumentCompleter -CommandName npm -ScriptBlock {
    Param($WordToComplete, $CommandAST, $CursorPosition)

    $Tokens = $CommandAST.Extent.Text.Trim() -Split '\s+'
    $Completions = switch ($Tokens[1]) {
        'install' { "-g", "--global"; break }
        Default { "install", "run", "start", "--help", "-h", "--version", "-v" }
    }

    $Completions | Where-Object { $_ -Like "${WordToComplete}*" } | ForEach-Object {
        [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
    }
}

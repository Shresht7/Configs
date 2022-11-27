# Commands Global
$Script:COMMANDS = @{'Next' = [System.Collections.ArrayList]::new() }

function Register-CommandCompleter(
    [Parameter(Mandatory)]
    [string] $Name,

    [string] $Tooltip,

    [Completion[]] $Completions
) {
    # Add Command to the Global $COMMANDS object
    $null = $Script:COMMANDS.Next.Add([Completion]::new($Name, $Tooltip, $Completions))
    
    # Register Auto-Complete Arguments
    Register-ArgumentCompleter -CommandName $Name -ScriptBlock {
        Param ($WordToComplete, $CommandAST, $CursorPosition)

        $Command = @(
            foreach ($Element in $CommandAST.CommandElements) {
                if (
                    $Element -isNot [Language.StringConstantExpressionAst] -or
                    $Element.StringConstantType -ne [Language.StringConstantType]::BareWord -or
                    $Element.Value.StartsWith('-') -or
                    $Element.Value -eq $WordToComplete
                ) { break }
                $Element.Value
            }
        )

        $Selection = $Script:COMMANDS
        foreach ($SubCommand in $Command) {
            $Selection = $Selection.Next | Where-Object { $_.Name -Like $SubCommand }
        }

        $Completions = $Selection.Next | Where-Object { $_.Name -Like "${WordToComplete}*" } | ForEach-Object {
            [CompletionResult]::new($_.Name, $_.Name, $_.Type, $_.Tooltip)
        }
        return $Completions
    }
}

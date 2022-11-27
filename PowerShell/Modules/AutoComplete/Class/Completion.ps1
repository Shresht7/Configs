# Namespaces
using namespace System.Management.Automation

# ----------------
# COMPLETION CLASS
# ----------------

# TODO: Support Aliases

class Completion {
    [string] $Name
    [string] $Tooltip
    [CompletionResultType] $Type = [CompletionResultType]::ParameterValue
    [Completion[]] $Next

    Completion([string] $Name) {
        $this.Name = $Name
        $this.Tooltip = $Name
        $this.Next = @()
    }

    Completion([string] $Name, [string] $Tooltip) {
        $this.Name = $Name
        $this.Tooltip = $Tooltip
        $this.Next = @()
    }

    Completion([string] $Name, [string] $Tooltip, [Completion[]] $Next) {
        $this.Name = $Name
        $this.Tooltip = $Tooltip
        $this.Next = $Next
    }
}

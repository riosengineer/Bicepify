@export()
@description('Common Entra Security Group(s) for RBAC')
var entraSecurityGroups = [
    SG_Cloud_Team: {
        displayName: 'SG_Cloud_Team',
        objectId: '11111111-1111-1111-1111-111111111111'
    }
    SG_Security_Team: {
        displayName: 'SG_Security_Team',
        objectId: '22222222-2222-2222-2222-222222222222'
    }
    SG_Dev_Team: {
        displayName: 'SG_Dev_Team',
        objectId: '33333333-3333-3333-3333-333333333333'
    }
]

@export()
@description('The Primary Azure Region location')
var location = 'uksouth'
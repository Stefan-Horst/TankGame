extends KinematicBody2D

class_name Actor

# can be moved to npc if it will be the only class inheriting actor (excluding player)
signal shoot_projectile(projectile, caller, location, direction)

var speed = 200
var angular_speed = 1
var hp = 100
var cooldown = 1

var Projectile = preload("res://entities/weapons/projectile.tscn")

onready var turret = $SpriteTurret
onready var projectile_pos = turret.get_node("SpriteGun/PosProjectile")


func remove_from_game():
	visible = false
	position = Vector2(-100, -100)
	rotation = 0
	turret.rotation = 0

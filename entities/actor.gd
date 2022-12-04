extends KinematicBody2D

class_name Actor

signal shoot_projectile(projectile, location, direction)

var speed = 200
var angular_speed = 1
var hp = 100
var cooldown = 1

var Projectile = preload("res://entities/weapons/projectile.tscn")

onready var turret = $SpriteTurret
onready var projectile_pos = turret.get_node("SpriteGun/PosProjectile")

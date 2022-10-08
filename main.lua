--[Made by Jozeni00]--
local ServerStorage = game:GetService("ServerStorage")
local HttpService = game:GetService("HttpService")
local DataSettings = {}
local function sigFigs(num: number): number
	local decimalLen = 3 -- length of decimals to save
	local newNum = math.floor(num * 10^decimalLen)/10^decimalLen

	return newNum
end
local function saveAttributes(obj)
	local attributes = nil
	local countAttributes = {}
	for i, v in pairs(obj:GetAttributes()) do
		table.insert(countAttributes, i)
	end
	if #countAttributes > 0 then
		attributes = {}
		for i, v in pairs(obj:GetAttributes()) do
			if type(v) == "string" or type(v) == "number" or type(v) == "boolean" then
				attributes[i] = v;
			elseif typeof(v) == "Rect" then
				attributes[i] = {
					["MinX"] = v.Min.X;
					["MinY"] = v.Min.Y;
					["MaxX"] = v.Max.X;
					["MaxY"] = v.Max.Y;
				};
			elseif typeof(v) == "BrickColor" then
				attributes[i] = {
					["r"] = sigFigs(v.r);
					["g"] = sigFigs(v.g);
					["b"] = sigFigs(v.b);
				};
			elseif typeof(v) == "Color3" then
				attributes[i] = {
					["R"] = sigFigs(v.R);
					["G"] = sigFigs(v.G);
					["B"] = sigFigs(v.B);
				};
			elseif typeof(v) == "NumberRange" then
				attributes[i] = {
					["Min"] = v.Min;
					["Max"] = v.Max;
				};
			elseif typeof(v) == "Vector3" then
				attributes[i] = {
					["X"] = v.X;
					["Y"] = v.Y;
					["Z"] = v.Z;
				};
			elseif typeof(v) == "Vector2" then
				attributes[i] = {
					["X2"] = v.X;
					["Y2"] = v.Y;
				};
			elseif typeof(v) == "UDim" then
				attributes[i] = {
					["Scale"] = v.Scale;
					["Offset"] = v.Offset;
				};
			elseif typeof(v) == "UDim2" then
				attributes[i] = {
					["XU"] = {
						["Scale"] = v.X.Scale;
						["Offset"] = v.X.Offset;
					};
					["YU"] = {
						["Scale"] = v.Y.Scale;
						["Offset"] = v.Y.Offset;
					};
				};
			elseif typeof(v) == "ColorSequence" then
				attributes[i] = {};
				for t, p in pairs(v.Keypoints) do
					attributes[i][t] = {
						["Time"] = sigFigs(p.Time);
						["Value"] = {
							["R"] = sigFigs(p.Value.R);
							["G"] = sigFigs(p.Value.G);
							["B"] = sigFigs(p.Value.B);
						};
					}
				end
			elseif typeof(v) == "NumberSequence" then
				attributes[i] = {};
				for t, p in pairs(v.Keypoints) do
					attributes[i][t] = {
						["Envelope"] = sigFigs(p.Envelope);
						["Time"] = sigFigs(p.Time);
						["Value"] = sigFigs(p.Value);
					}
				end
			elseif typeof(v) == "Font" then
				local weight = tostring(v.Weight):split(".")
				local style = tostring(v.Style):split(".")
				attributes[i] = {
					["Family"] = v.Family;
					["Weight"] = {
						["EnumType"] = weight[2];
						["Name"] = weight[3];
					};
					["Style"] = {
						["EnumType"] = style[2];
						["Name"] = style[3];
					};
				};
			end
		end
	end
	if attributes then
		return HttpService:JSONEncode(attributes)
	else
		return nil
	end
end
local function getProp(prop)
	local Data = {}
	if typeof(prop) == "ColorSequence" then
		for i, v in pairs(prop.Keypoints) do
			Data[i] = {
				["Time"] = sigFigs(v.Time);
				["Value"] = {
					["R"] = sigFigs(v.Value.R);
					["G"] = sigFigs(v.Value.G);
					["B"] = sigFigs(v.Value.B);
				};
			}
		end
	elseif typeof(prop) == "NumberSequence" then
		for i, v in pairs(prop.Keypoints) do
			Data[i] = {
				["Envelope"] = sigFigs(v.Envelope);
				["Time"] = sigFigs(v.Time);
				["Value"] = sigFigs(v.Value);
			}
		end
	elseif typeof(prop) == "NumberRange" then
		Data = {
			["Min"] = prop.Min;
			["Max"] = prop.Max;
		};
	elseif typeof(prop) == "Vector3" then
		Data = {
			["X"] = sigFigs(prop.X);
			["Y"] = sigFigs(prop.Y);
			["Z"] = sigFigs(prop.Z);
		}
	elseif typeof(prop) == "Vector2" then
		Data = {
			["X2"] = sigFigs(prop.X);
			["Y2"] = sigFigs(prop.Y);
		}
	elseif typeof(prop) == "Color3" then
		Data = {
			["R"] = sigFigs(prop.R);
			["G"] = sigFigs(prop.G);
			["B"] = sigFigs(prop.B);
		}
	elseif typeof(prop) == "BrickColor" then
		Data = {
			["r"] = sigFigs(prop.r);
			["g"] = sigFigs(prop.g);
			["b"] = sigFigs(prop.b);
		}
	elseif typeof(prop) == "Ray" then
		Data = {
			["x"] = sigFigs(prop.Origin.X);
			["y"] = sigFigs(prop.Origin.Y);
			["z"] = sigFigs(prop.Origin.Z);
			["dx"] = sigFigs(prop.Direction.X);
			["dy"] = sigFigs(prop.Direction.Y);
			["dz"] = sigFigs(prop.Direction.Z);
		}
	elseif typeof(prop) == "CFrame" then
		local components = {prop:components()}
		for i, v in pairs(components) do
			components[i] = sigFigs(v)
		end

		Data = {
			["x"] = components[1] or 0;
			["y"] = components[2] or 0;
			["z"] = components[3] or 0;
			["R00"] = components[4] or 1;
			["R01"] = components[5] or 0;
			["R02"] = components[6] or 0;
			["R10"] = components[7] or 0;
			["R11"] = components[8] or 1;
			["R12"] = components[9] or 0;
			["R20"] = components[10] or 0;
			["R21"] = components[11] or 0;
			["R22"] = components[12] or 1;
		}
	elseif typeof(prop) == "Rect" then
		Data = {
			["MinX"] = prop.Min.X;
			["MinY"] = prop.Min.Y;
			["MaxX"] = prop.Max.X;
			["MaxY"] = prop.Max.Y;
		}
	elseif typeof(prop) == "UDim" then
		Data = {
			["Scale"] = prop.Scale;
			["Offset"] = prop.Offset;
		};
	elseif typeof(prop) == "UDim2" then
		Data = {
			["XU"] = {
				["Scale"] = prop.X.Scale;
				["Offset"] = prop.X.Offset;
			};
			["YU"] = {
				["Scale"] = prop.Y.Scale;
				["Offset"] = prop.Y.Offset;
			};
		};
	elseif typeof(prop) == "EnumItem" then
		local enumItem = tostring(prop):split(".")
		Data = {
			["EnumType"] = enumItem[2];
			["Name"] = enumItem[3];
		}
	elseif typeof(prop) == "Axes" then
		Data = {
			["AX"] = prop.X;
			["AY"] = prop.Y;
			["AZ"] = prop.Z;
		}
		if prop.X then
			if prop.Left then
				Data["Left"] = Enum.NormalId.Left.Name
			end
			if prop.Right then
				Data["Right"] = Enum.NormalId.Right.Name
			end
		end
		if prop.Y then
			if prop.Top then
				Data["Top"] = Enum.NormalId.Top.Name
			end
			if prop.Bottom then
				Data["Bottom"] = Enum.NormalId.Bottom.Name
			end
		end
		if prop.Z then
			if prop.Back then
				Data["Back"] = Enum.NormalId.Back.Name
			end
			if prop.Front then
				Data["Front"] = Enum.NormalId.Front.Name
			end
		end
	elseif typeof(prop) == "Faces" then
		Data = {
			["Top"] = prop.Top;
			["Bottom"] = prop.Bottom;
			["Left"] = prop.Left;
			["Right"] = prop.Right;
			["Back"] = prop.Back;
			["Front"] = prop.Front;
		}
		if prop.Left then
			Data["Left"] = Enum.NormalId.Left.Name
		end
		if prop.Right then
			Data["Right"] = Enum.NormalId.Right.Name
		end
		if prop.Top then
			Data["Top"] = Enum.NormalId.Top.Name
		end
		if prop.Bottom then
			Data["Bottom"] = Enum.NormalId.Bottom.Name
		end
		if prop.Back then
			Data["Back"] = Enum.NormalId.Back.Name
		end
		if prop.Front then
			Data["Front"] = Enum.NormalId.Front.Name
		end
	end
	return Data
end
local function saveParts(Object, Data, num)
	if Object then
		local holdName = ""
		if not Data then
			Data = {}
		end
		if num then
			holdName = Object.Name .. "x" .. num
		else
			holdName = Object.Name --.. "x1"
		end
		Data[holdName] = {
			["Archivable"] = Object.Archivable;
			["ClassName"] = Object.ClassName;
			["Name"] = Object.Name;
			["Parent"] = Object.Parent.Name;
			["Attributes"] = saveAttributes(Object);
		}
		if Object:IsA("PVInstance") then
			if Object:IsA("Model") then
				Data[holdName]["PrimaryPart"] = false
				if Object.PrimaryPart then
					Data[holdName]["PrimaryPart"] = Object.PrimaryPart.Name
				end
				Data[holdName]["WorldPivot"] = getProp(Object:GetPivot())
			elseif Object:IsA("BasePart") then
				local components = {Object.CFrame:components()}
				--Appearance
				Data[holdName]["CastShadow"] = Object.CastShadow;
				Data[holdName]["Color"] = getProp(Object.Color);
				Data[holdName]["Material"] = getProp(Object.Material);
				Data[holdName]["Reflectance"] = sigFigs(Object.Reflectance);
				Data[holdName]["Transparency"] = sigFigs(Object.Transparency);
				--Data
				Data[holdName]["Locked"] = Object.Locked;
				Data[holdName]["CFrame"] = getProp(Object.CFrame);
				--Collision
				Data[holdName]["CanCollide"] = Object.CanCollide;
				Data[holdName]["CanTouch"] = Object.CanTouch;
				Data[holdName]["CollisionGroupId"] = Object.CollisionGroupId;
				--Behavior
				Data[holdName]["Anchored"] = Object.Anchored;
				Data[holdName]["Massless"] = Object.Massless;
				Data[holdName]["RootPriority"] = Object.RootPriority;
				Data[holdName]["Size"] = getProp(Object.Size);
				--Surface
				Data[holdName]["TopSurface"] = getProp(Object.TopSurface);
				Data[holdName]["BottomSurface"] = getProp(Object.BottomSurface);
				Data[holdName]["FrontSurface"] = getProp(Object.FrontSurface);
				Data[holdName]["BackSurface"] = getProp(Object.BackSurface);
				Data[holdName]["LeftSurface"] = getProp(Object.LeftSurface);
				Data[holdName]["RightSurface"] = getProp(Object.RightSurface);
				if Object:IsA("Part") then
					Data[holdName]["Shape"] = getProp(Object.Shape)
					if Object:IsA("Seat") then
						Data[holdName]["Disabled"] = Object.Disabled
					elseif Object:IsA("SpawnLocation") then
						Data[holdName]["AllowTeamChangeOnTouch"] = Object.AllowTeamChangeOnTouch
						Data[holdName]["Duration"] = Object.Duration
						Data[holdName]["Enabled"] = Object.Enabled
						Data[holdName]["Neutral"] = Object.Neutral
						Data[holdName]["TeamColor"] = getProp(Object.TeamColor)
					end
				elseif Object:IsA("VehicleSeat") then
					Data[holdName]["Disabled"] = Object.Disabled
					Data[holdName]["HeadsUpDisplay"] = Object.HeadsUpDisplay
					Data[holdName]["MaxSpeed"] = Object.MaxSpeed
					Data[holdName]["SteerFloat"] = Object.SteerFloat
					Data[holdName]["ThrottleFloat"] = Object.ThrottleFloat
					Data[holdName]["Torque"] = Object.Torque
					Data[holdName]["TurnSpeed"] = Object.TurnSpeed
				elseif Object:IsA("TrussPart") then
					Data[holdName]["Style"] = getProp(Object.Style)
				elseif Object:IsA("MeshPart") then
					Data[holdName]["MeshId"] = Object.MeshId
					Data[holdName]["TextureID"] = Object.TextureID
					Data[holdName]["DoubleSided"] = Object.DoubleSided
					Data[holdName]["RenderFidelity"] = getProp(Object.RenderFidelity)
					Data[holdName]["CollisionFidelity"] = getProp(Object.CollisionFidelity)
				end
			end
		elseif Object:IsA("DataModelMesh") then
			Data[holdName]["Offset"] = getProp(Object.Offset);
			Data[holdName]["Scale"] = getProp(Object.Scale);
			Data[holdName]["VertexColor"] = getProp(Object.VertexColor);
			if Object:IsA("SpecialMesh") then
				Data[holdName]["MeshType"] = getProp(Object.MeshType)
				Data[holdName]["MeshId"] = Object.MeshId
				Data[holdName]["TextureId"] = Object.TextureId
			end
		elseif Object:IsA("Tool") then
			Data[holdName]["CanBeDropped"] = Object.CanBeDropped
			Data[holdName]["Enabled"] = Object.Enabled
			Data[holdName]["Grip"] = getProp(Object.Grip)
			Data[holdName]["ManualActivationOnly"] = Object.ManualActivationOnly
			Data[holdName]["RequiresHandle"] = Object.RequiresHandle
			Data[holdName]["TextureId"] = Object.TextureId
			Data[holdName]["ToolTip"] = Object.ToolTip
		elseif Object:IsA("SurfaceAppearance") then
			Data[holdName]["AlphaMode"] = getProp(Object.AlphaMode)
			Data[holdName]["ColorMap"] = Object.ColorMap
			Data[holdName]["MetalnessMap"] = Object.MetalnessMap
			Data[holdName]["NormalMap"] = Object.NormalMap
			Data[holdName]["RoughnessMap"] = Object.RoughnessMap
		elseif Object:IsA("Accoutrement") then
			Data[holdName]["AttachmentPoint"] = getProp(Object.AttachmentPoint)
			if Object:IsA("Accessory") then
				Data[holdName]["AccessoryType"] = getProp(Object.AccessoryType)
			end
		elseif Object:IsA("Camera") then
			Data[holdName]["CFrame"] = getProp(Object.CFrame)
			if Object.CameraSubject then
				Data[holdName]["CameraSubject"] = {
					["Location"] = Object.CameraSubject:GetFullName();
					["ClassName"] = Object.CameraSubject.ClassName;
				}
			end
			Data[holdName]["CameraType"] = getProp(Object.CameraType)
			Data[holdName]["DiagonalFieldOfView"] = Object.DiagonalFieldOfView
			Data[holdName]["FieldOfView"] = Object.FieldOfView
			Data[holdName]["FieldOfViewMode"] = Object.FieldOfViewMode
			Data[holdName]["Focus"] = getProp(Object.Focus)
			Data[holdName]["HeadLocked"] = Object.HeadLocked
			Data[holdName]["HeadScale"] = Object.HeadScale
			Data[holdName]["MaxAxisFieldOfView"] = Object.MaxAxisFieldOfView
		elseif Object:IsA("Humanoid") then
			Data[holdName]["AutoJumpEnabled"] = Object.AutoJumpEnabled
			Data[holdName]["AutoRotate"] = Object.AutoRotate
			Data[holdName]["AutomaticScalingEnabled"] = Object.AutomaticScalingEnabled
			Data[holdName]["BreakJointsOnDeath"] = Object.BreakJointsOnDeath
			Data[holdName]["CameraOffset"] = getProp(Object.CameraOffset)
			Data[holdName]["DisplayDistanceType"] = getProp(Object.DisplayDistanceType)
			Data[holdName]["DisplayName"] = Object.DisplayName
			Data[holdName]["MaxHealth"] = Object.MaxHealth
			Data[holdName]["Health"] = Object.Health
			Data[holdName]["HealthDisplayDistance"] = Object.HealthDisplayDistance
			Data[holdName]["HealthDisplayType"] = getProp(Object.HealthDisplayType)
			Data[holdName]["HipHeight"] = Object.HipHeight
			Data[holdName]["UseJumpPower"] = Object.UseJumpPower
			Data[holdName]["RequiresNeck"] = Object.RequiresNeck
			Data[holdName]["WalkSpeed"] = Object.WalkSpeed
			Data[holdName]["JumpHeight"] = Object.JumpHeight
			Data[holdName]["JumpPower"] = Object.JumpPower
			Data[holdName]["MaxSlopeAngle"] = Object.MaxSlopeAngle
			Data[holdName]["TargetPoint"] = getProp(Object.TargetPoint)
			Data[holdName]["NameDisplayDistance"] = Object.NameDisplayDistance
			Data[holdName]["NameOcclusion"] = getProp(Object.NameOcclusion)
			Data[holdName]["PlatformStand"] = Object.PlatformStand
			Data[holdName]["RigType"] = getProp(Object.RigType)
			Data[holdName]["Sit"] = Object.Sit
			Data[holdName]["WalkToPoint"] = getProp(Object.WalkToPoint)
		elseif Object:IsA("HumanoidDescription") then
			Data[holdName]["BackAccessory"] = Object.BackAccessory
			Data[holdName]["BodyTypeScale"] = Object.BodyTypeScale
			Data[holdName]["ClimbAnimation"] = Object.ClimbAnimation
			Data[holdName]["DepthScale"] = Object.DepthScale
			Data[holdName]["Face"] = Object.Face
			Data[holdName]["FaceAccessory"] = Object.FaceAccessory
			Data[holdName]["FallAnimation"] = Object.FallAnimation
			Data[holdName]["FrontAccessory"] = Object.FrontAccessory
			Data[holdName]["GraphicTShirt"] = Object.GraphicTShirt
			Data[holdName]["HairAccessory"] = Object.HairAccessory
			Data[holdName]["HatAccessory"] = Object.HatAccessory
			Data[holdName]["Head"] = Object.Head
			Data[holdName]["HeadColor"] = getProp(Object.HeadColor)
			Data[holdName]["HeadScale"] = Object.HeadScale
			Data[holdName]["HeightScale"] = Object.HeightScale
			Data[holdName]["IdleAnimation"] = Object.IdleAnimation
			Data[holdName]["JumpAnimation"] = Object.JumpAnimation
			Data[holdName]["LeftArm"] = Object.LeftArm
			Data[holdName]["LeftArmColor"] = getProp(Object.LeftArmColor)
			Data[holdName]["LeftLeg"] = Object.LeftLeg
			Data[holdName]["LeftLegColor"] = getProp(Object.LeftLegColor)
			Data[holdName]["NeckAccessory"] = Object.NeckAccessory
			Data[holdName]["Pants"] = Object.Pants
			Data[holdName]["ProportionScale"] = Object.ProportionScale
			Data[holdName]["RightArm"] = Object.RightArm
			Data[holdName]["RightArmColor"] = getProp(Object.RightArmColor)
			Data[holdName]["RightLeg"] = Object.RightLeg
			Data[holdName]["RightLegColor"] = getProp(Object.RightLegColor)
			Data[holdName]["RunAnimation"] = Object.RunAnimation
			Data[holdName]["Shirt"] = Object.Shirt
			Data[holdName]["ShouldersAccessory"] = Object.ShouldersAccessory
			Data[holdName]["SwimAnimation"] = Object.SwimAnimation
			Data[holdName]["Torso"] = Object.Torso
			Data[holdName]["TorsoColor"] = getProp(Object.TorsoColor)
			Data[holdName]["WaistAccessory"] = Object.WaistAccessory
			Data[holdName]["WalkAnimation"] = Object.WalkAnimation
			Data[holdName]["WidthScale"] = Object.WidthScale
		elseif Object:IsA("BodyColors") then
			Data[holdName]["HeadColor3"] = getProp(Object.HeadColor3)
			Data[holdName]["TorsoColor3"] = getProp(Object.TorsoColor3)
			Data[holdName]["LeftArmColor3"] = getProp(Object.LeftArmColor3)
			Data[holdName]["LeftLegColor3"] = getProp(Object.LeftLegColor3)
			Data[holdName]["RightArmColor3"] = getProp(Object.RightArmColor3)
			Data[holdName]["RightLegColor3"] = getProp(Object.RightLegColor3)
		elseif Object:IsA("Clothing") then
			Data[holdName]["Color3"] = getProp(Object.Color3)
			if Object:IsA("Shirt") then
				Data[holdName]["ShirtTemplate"] = Object.ShirtTemplate
			elseif Object:IsA("Pants") then
				Data[holdName]["PantsTemplate"] = Object.PantsTemplate
			end
		elseif Object:IsA("ShirtGraphic") then
			Data[holdName]["Color3"] = getProp(Object.Color3)
			Data[holdName]["Graphic"] = Object.Graphic
		elseif Object:IsA("WrapLayer") then
			Data[holdName]["BindOffset"] = getProp(Object.BindOffset)
			Data[holdName]["Enabled"] = Object.Enabled
			Data[holdName]["Order"] = Object.Order
			Data[holdName]["Puffiness"] = Object.Puffiness
			Data[holdName]["ReferenceMeshId"] = Object.ReferenceMeshId
			Data[holdName]["ReferenceOrigin"] = getProp(Object.ReferenceOrigin)
			Data[holdName]["ShrinkFactor"] = Object.ShrinkFactor
		elseif Object:IsA("WrapTarget") then
			Data[holdName]["Stiffness"] = Object.Stiffness
		elseif Object:IsA("JointInstance") then
			Data[holdName]["C0"] = getProp(Object.C0)
			Data[holdName]["C1"] = getProp(Object.C1)
			Data[holdName]["Enabled"] = Object.Enabled
			if Object.Part0 then
				Data[holdName]["Part0"] = {
					["Location"] = Object.Part0:GetFullName();
					["ClassName"] = Object.Part0.ClassName;
				}
			end
			if Object.Part1 then
				Data[holdName]["Part1"] = {
					["Location"] = Object.Part1:GetFullName();
					["ClassName"] = Object.Part1.ClassName;
				}
			end
			if Object:IsA("Motor") then
				Data[holdName]["CurrentAngle"] = Object.CurrentAngle
				Data[holdName]["DesiredAngle"] = Object.DesiredAngle
				Data[holdName]["MaxVelocity"] = Object.MaxVelocity
				if Object:IsA("Motor6D") then
					--Data[holdName]["Transform"] = getProp(Object.Transform)
				end
			end
		elseif Object:IsA("ForceField") then
			Data[holdName]["Visible"] = Object.Visible
		elseif Object:IsA("Animation") then
			Data[holdName]["AnimationId"] = Object.AnimationId
		elseif Object:IsA("Team") then
			Data[holdName]["AutoAssignable"] = Object.AutoAssignable
			Data[holdName]["TeamColor"] = getProp(Object.TeamColor)
		elseif Object:IsA("ClickDetector") then
			Data[holdName]["CursorIcon"] = Object.CursorIcon
			Data[holdName]["MaxActivationDistance"] = Object.MaxActivationDistance
		elseif Object:IsA("ProximityPrompt") then
			Data[holdName]["ActionText"] = Object.ActionText
			Data[holdName]["AutoLocalize"] = Object.AutoLocalize
			Data[holdName]["ClickablePrompt"] = Object.ClickablePrompt
			Data[holdName]["Enabled"] = Object.Enabled
			Data[holdName]["Exclusivity"] = getProp(Object.Exclusivity)
			Data[holdName]["GamepadKeyCode"] = getProp(Object.GamepadKeyCode)
			Data[holdName]["HoldDuration"] = Object.HoldDuration
			Data[holdName]["KeyboardKeyCode"] = getProp(Object.KeyboardKeyCode)
			Data[holdName]["MaxActivationDistance"] = Object.MaxActivationDistance
			Data[holdName]["ObjectText"] = Object.ObjectText
			Data[holdName]["RequiresLineOfSight"] = Object.RequiresLineOfSight
			if Object.RootLocalizationTable then
				Data[holdName]["RootLocalizationTable"] = {
					["Location"] = Object.RootLocalizationTable:GetFullName();
					["ClassName"] = Object.RootLocalizationTable.ClassName;
				}
			end
			Data[holdName]["Style"] = getProp(Object.Style)
			Data[holdName]["UIOffset"] = getProp(Object.UIOffset)
		elseif Object:IsA("Dialog") then
			Data[holdName]["BehaviorType"] = getProp(Object.BehaviorType)
			Data[holdName]["ConversationDistance"] = Object.ConversationDistance
			Data[holdName]["GoodbyeChoiceActive"] = Object.GoodbyeChoiceActive
			Data[holdName]["GoodbyeDialog"] = Object.GoodbyeDialog
			Data[holdName]["InUse"] = Object.InUse
			Data[holdName]["InitialPrompt"] = Object.InitialPrompt
			Data[holdName]["Purpose"] = getProp(Object.Purpose)
			Data[holdName]["Tone"] = getProp(Object.Tone)
			Data[holdName]["TriggerDistance"] = Object.TriggerDistance
			Data[holdName]["UIOffset"] = getProp(Object.UIOffset)
		elseif Object:IsA("DialogChoice") then
			Data[holdName]["GoodbyeChoiceActive"] = Object.GoodbyeChoiceActive
			Data[holdName]["GoodbyeDialog"] = Object.GoodbyeDialog
			Data[holdName]["ResponseDialog"] = Object.ResponseDialog
			Data[holdName]["UserDialog"] = Object.UserDialog
		elseif Object:IsA("PathfindingModifier") then
			Data[holdName]["Label"] = Object.Label
			Data[holdName]["PassThrough"] = Object.PassThrough
		elseif Object:IsA("SoundGroup") then
			Data[holdName]["Volume"] = Object.Volume
		elseif Object:IsA("Sound") then
			Data[holdName]["Looped"] = Object.Looped;
			Data[holdName]["PlayOnRemove"] = Object.PlayOnRemove;
			Data[holdName]["PlaybackSpeed"] = Object.PlaybackSpeed;
			Data[holdName]["Playing"] = Object.Playing;
			Data[holdName]["RollOffMaxDistance"] = Object.RollOffMaxDistance;
			Data[holdName]["RollOffMinDistance"] = Object.RollOffMinDistance;
			Data[holdName]["RollOffMode"] = getProp(Object.RollOffMode);
			if Object.SoundGroup then
				Data[holdName]["SoundGroup"] = {
					["Location"] = Object.SoundGroup:GetFullName();
					["ClassName"] = Object.SoundGroup.ClassName;
				}
			end
			Data[holdName]["SoundId"] = Object.SoundId;
			Data[holdName]["TimePosition"] = Object.TimePosition;
			Data[holdName]["Volume"] = Object.Volume;
		elseif Object:IsA("SoundEffect") then
			Data[holdName]["Enabled"] = Object.Enabled
			Data[holdName]["Priority"] = Object.Priority
			if Object:IsA("ChorusSoundEffect") then
				Data[holdName]["Depth"] = Object.Depth
				Data[holdName]["Mix"] = Object.Mix
				Data[holdName]["Rate"] = Object.Rate
			elseif Object:IsA("DistortionSoundEffect") then
				Data[holdName]["Level"] = Object.Level
			elseif Object:IsA("EchoSoundEffect") then
				Data[holdName]["Delay"] = Object.Delay
				Data[holdName]["DryLevel"] = Object.DryLevel
				Data[holdName]["Feedback"] = Object.Feedback
				Data[holdName]["WetLevel"] = Object.WetLevel
			elseif Object:IsA("EqualizerSoundEffect") then
				Data[holdName]["HighGain"] = Object.HighGain
				Data[holdName]["LowGain"] = Object.LowGain
				Data[holdName]["MidGain"] = Object.MidGain
			elseif Object:IsA("PitchShiftSoundEffect") then
				Data[holdName]["Octave"] = Object.Octave
			elseif Object:IsA("ReverbSoundEffect") then
				Data[holdName]["DecayTime"] = Object.DecayTime
				Data[holdName]["Density"] = Object.Density
				Data[holdName]["Diffusion"] = Object.Diffusion
				Data[holdName]["DryLevel"] = Object.DryLevel
				Data[holdName]["WetLevel"] = Object.WetLevel
			elseif Object:IsA("TremoloSoundEffect") then
				Data[holdName]["Depth"] = Object.Depth
				Data[holdName]["Duty"] = Object.Duty
				Data[holdName]["Frequency"] = Object.Frequency
			end
		elseif Object:IsA("ParticleEmitter") then --effects
			--Appearance
			Data[holdName]["Color"] = getProp(Object.Color);
			Data[holdName]["LightEmission"] = Object.LightEmission;
			Data[holdName]["LightInfluence"] = Object.LightInfluence;
			Data[holdName]["Orientation"] = getProp(Object.Orientation);
			Data[holdName]["Size"] = getProp(Object.Size);
			Data[holdName]["Squash"] = getProp(Object.Squash);
			Data[holdName]["Texture"] = Object.Texture;
			Data[holdName]["Transparency"] = getProp(Object.Transparency);
			Data[holdName]["ZOffset"] = Object.ZOffset;
			--Emission
			Data[holdName]["EmissionDirection"] = getProp(Object.EmissionDirection);
			Data[holdName]["Enabled"] = Object.Enabled;
			Data[holdName]["Lifetime"] = getProp(Object.Lifetime);
			Data[holdName]["Rate"] = Object.Rate;
			Data[holdName]["Rotation"] = getProp(Object.Rotation);
			Data[holdName]["RotSpeed"] = getProp(Object.RotSpeed);
			Data[holdName]["Speed"] = getProp(Object.Speed);
			Data[holdName]["SpreadAngle"] = getProp(Object.SpreadAngle);
			--EmitterShape
			Data[holdName]["Shape"] = getProp(Object.Shape);
			Data[holdName]["ShapeInOut"] = getProp(Object.ShapeInOut);
			Data[holdName]["ShapeStyle"] = getProp(Object.ShapeStyle);
			--Motion
			Data[holdName]["Acceleration"] = getProp(Object.Acceleration);
			--Particles
			Data[holdName]["Drag"] = Object.Drag;
			Data[holdName]["LockedToPart"] = Object.LockedToPart;
			Data[holdName]["TimeScale"] = Object.TimeScale;
			Data[holdName]["VelocityInheritance"] = Object.VelocityInheritance;
		elseif Object:IsA("Beam") then
			--Appearance
			Data[holdName]["Color"] = getProp(Object.Color);
			Data[holdName]["Enabled"] = Object.Enabled;
			Data[holdName]["LightEmission"] = Object.LightEmission;
			Data[holdName]["LightInfluence"] = Object.LightInfluence;
			Data[holdName]["Texture"] = Object.Texture;
			Data[holdName]["TextureLength"] = Object.TextureLength;
			Data[holdName]["TextureMode"] = getProp(Object.TextureMode);
			Data[holdName]["TextureSpeed"] = Object.TextureSpeed;
			Data[holdName]["Transparency"] = getProp(Object.Transparency);
			Data[holdName]["ZOffset"] = Object.ZOffset;
			--shape
			if Object.Attachment0 then
				Data[holdName]["Attachment0"] = {
					["Location"] = Object.Attachment0:GetFullName();
					["ClassName"] = Object.Attachment0.ClassName;
				}
			end
			if Object.Attachment1 then
				Data[holdName]["Attachment1"] = {
					["Location"] = Object.Attachment1:GetFullName();
					["ClassName"] = Object.Attachment1.ClassName;
				}
			end
			Data[holdName]["CurveSize0"] = Object.CurveSize0;
			Data[holdName]["CurveSize1"] = Object.CurveSize1;
			Data[holdName]["FaceCamera"] = Object.FaceCamera;
			Data[holdName]["Segments"] = Object.Segments;
			Data[holdName]["Width0"] = Object.Width0;
			Data[holdName]["Width1"] = Object.Width1;
		elseif Object:IsA("Explosion") then
			Data[holdName]["BlastPreasure"] = Object.BlastPreasure;
			Data[holdName]["BlastRadius"] = Object.BlastRadius;
			Data[holdName]["DestroyJointRadiusPercent"] = Object.DestroyJointRadiusPercent;
			Data[holdName]["ExplosionType"] = getProp(Object.ExplosionType);
			Data[holdName]["Position"] = getProp(Object.Position);
			Data[holdName]["TimeScale"] = Object.TimeScale;
			Data[holdName]["Visible"] = Object.Visible;
		elseif Object:IsA("Fire") then
			Data[holdName]["Color"] = getProp(Object.Color);
			Data[holdName]["Enabled"] = Object.Enabled;
			Data[holdName]["Heat"] = Object.Heat;
			Data[holdName]["SecondaryColor"] = getProp(Object.SecondaryColor);
			Data[holdName]["Size"] = Object.Size;
			Data[holdName]["TimeScale"] = Object.TimeScale;
		elseif Object:IsA("Highlight") then
			if Object.Adornee then
				Data[holdName]["Adornee"] = {
					["Location"] = Object.Adornee:GetFullName();
					["ClassName"] = Object.Adornee.ClassName;
				}
			end
			Data[holdName]["DepthMode"] = getProp(Object.DepthMode)
			Data[holdName]["Enabled"] = Object.Enabled;
			Data[holdName]["FillColor"] = getProp(Object.FillColor);
			Data[holdName]["FillTransparency"] = Object.FillTransparency
			Data[holdName]["OutlineColor"] = getProp(Object.OutlineColor);
			Data[holdName]["OutlineTransparency"] = Object.OutlineTransparency
		elseif Object:IsA("Smoke") then
			Data[holdName]["Color"] = getProp(Object.Color);
			Data[holdName]["Enabled"] = Object.Enabled;
			Data[holdName]["Opacity"] = Object.Opacity;
			Data[holdName]["RiseVelocity"] = Object.RiseVelocity;
			Data[holdName]["Size"] = Object.Size;
			Data[holdName]["TimeScale"] = Object.TimeScale;
		elseif Object:IsA("Sparkles") then
			Data[holdName]["Color"] = getProp(Object.Color);
			Data[holdName]["Enabled"] = Object.Enabled;
			Data[holdName]["SparkleColor"] = getProp(Object.SparkleColor);
			Data[holdName]["TimeScale"] = Object.TimeScale;
		elseif Object:IsA("Trail") then
			--shape
			if Object.Attachment0 then
				Data[holdName]["Attachment0"] = {
					["Location"] = Object.Attachment0:GetFullName();
					["ClassName"] = Object.Attachment0.ClassName;
				}
			end
			if Object.Attachment1 then
				Data[holdName]["Attachment1"] = {
					["Location"] = Object.Attachment1:GetFullName();
					["ClassName"] = Object.Attachment1.ClassName;
				}
			end
			Data[holdName]["Brightness"] = Object.Brightness;
			Data[holdName]["Color"] = getProp(Object.Color);
			Data[holdName]["Enabled"] = Object.Enabled;
			Data[holdName]["FaceCamera"] = Object.FaceCamera;
			Data[holdName]["Lifetime"] = Object.Lifetime;
			Data[holdName]["LightEmission"] = Object.LightEmission;
			Data[holdName]["LightInfluence"] = Object.LightInfluence;
			Data[holdName]["MaxLength"] = Object.MaxLength;
			Data[holdName]["MinLength"] = Object.MinLength;
			Data[holdName]["Texture"] = Object.Texture;
			Data[holdName]["TextureLength"] = Object.TextureLength;
			Data[holdName]["TextureMode"] = getProp(Object.TextureMode);
			Data[holdName]["Transparency"] = getProp(Object.Transparency);
			Data[holdName]["WidthScale"] = getProp(Object.WidthScale);
		elseif Object:IsA("Attachment") then
			Data[holdName]["Visible"] = Object.Visible
			Data[holdName]["CFrame"] = getProp(Object.CFrame)
			Data[holdName]["WorldCFrame"] = getProp(Object.WorldCFrame)
			if Object:IsA("Bone") then
				Data[holdName]["Transform"] = getProp(Object.Transform)
			end
		elseif Object:IsA("Decal") then
			--Appearance
			Data[holdName]["Color3"] = getProp(Object.Color3)
			Data[holdName]["Texture"] = Object.Texture
			Data[holdName]["Transparency"] = Object.Transparency
			Data[holdName]["ZIndex"] = Object.ZIndex
			--Data
			Data[holdName]["Face"] = getProp(Object.Face)
			if Object:IsA("Texture") then
				Data[holdName]["OffsetStudsU"] = Object.OffsetStudsU
				Data[holdName]["OffsetStudsV"] = Object.OffsetStudsV
				Data[holdName]["StudsPerTileU"] = Object.StudsPerTileU
				Data[holdName]["StudsPerTileV"] = Object.StudsPerTileV
			end
		elseif Object:IsA("Atmosphere") then
			Data[holdName]["Color"] = getProp(Object.Color)
			Data[holdName]["Decay"] = getProp(Object.Decay)
			Data[holdName]["Density"] = Object.Density
			Data[holdName]["Glare"] = Object.Glare
			Data[holdName]["Haze"] = Object.Haze
			Data[holdName]["Offset"] = Object.Offset
		elseif Object:IsA("Clouds") then
			Data[holdName]["Color"] = getProp(Object.Color)
			Data[holdName]["Cover"] = Object.Cover
			Data[holdName]["Density"] = Object.Density
			Data[holdName]["Enabled"] = Object.Enabled
		elseif Object:IsA("Sky") then
			Data[holdName]["CelestialBodiesShown"] = Object.CelestialBodiesShown
			Data[holdName]["MoonAngularSize"] = Object.MoonAngularSize
			Data[holdName]["MoonTextureId"] = Object.MoonTextureId
			Data[holdName]["SkyboxBk"] = Object.SkyboxBk
			Data[holdName]["SkyboxDn"] = Object.SkyboxDn
			Data[holdName]["SkyboxFt"] = Object.SkyboxFt
			Data[holdName]["SkyboxLf"] = Object.SkyboxLf
			Data[holdName]["SkyboxRt"] = Object.SkyboxRt
			Data[holdName]["SkyboxUp"] = Object.SkyboxUp
			Data[holdName]["StarCount"] = Object.StarCount
			Data[holdName]["SunAngularSize"] = Object.SunAngularSize
			Data[holdName]["SunTextureId"] = Object.SunTextureId
		elseif Object:IsA("PostEffect") then
			Data[holdName]["Enabled"] = Object.Enabled
			if Object:IsA("BloomEffect") then
				Data[holdName]["Intensity"] = Object.Intensity
				Data[holdName]["Size"] = Object.Size
				Data[holdName]["Threshold"] = Object.Threshold
			elseif Object:IsA("BlurEffect") then
				Data[holdName]["Size"] = Object.Size
			elseif Object:IsA("ColorCorrectionEffect") then
				Data[holdName]["Brightness"] = Object.Brightness
				Data[holdName]["Contrast"] = Object.Contrast
				Data[holdName]["Saturation"] = Object.Saturation
				Data[holdName]["TintColor"] = getProp(Object.TintColor)
			elseif Object:IsA("DepthOfFieldEffect") then
				Data[holdName]["FarIntensity"] = Object.FarIntensity
				Data[holdName]["FocusDistance"] = Object.FocusDistance
				Data[holdName]["InFocusRadius"] = Object.InFocusRadius
				Data[holdName]["NearIntensity"] = Object.NearIntensity
			elseif Object:IsA("SunRaysEffect") then
				Data[holdName]["Intensity"] = Object.Intensity
				Data[holdName]["Spread"] = Object.Spread
			end
		elseif Object:IsA("Light") then
			Data[holdName]["Brightness"] = Object.Brightness
			Data[holdName]["Color"] = getProp(Object.Color)
			Data[holdName]["Enabled"] = Object.Enabled
			Data[holdName]["Shadows"] = Object.Shadows
			if Object:IsA("PointLight") then
				Data[holdName]["Range"] = Object.Range
			elseif Object:IsA("SurfaceLight") then
				Data[holdName]["Angle"] = Object.Angle
				Data[holdName]["Face"] = getProp(Object.Face)
				Data[holdName]["Range"] = Object.Range
			elseif Object:IsA("SpotLight") then
				Data[holdName]["Angle"] = Object.Angle
				Data[holdName]["Face"] = getProp(Object.Face)
				Data[holdName]["Range"] = Object.Range
			end
		elseif Object:IsA("ValueBase") then
			if Object:IsA("CFrameValue") or Object:IsA("Vector3Value") or Object:IsA("RayValue") or Object:IsA("Color3Value") or Object:IsA("BrickColorValue") then
				Data[holdName]["Value"] = getProp(Object.Value)
			elseif Object:IsA("ObjectValue") then
				Data[holdName]["Value"] = saveParts(Object.Value)
			else
				Data[holdName]["Value"] = Object.Value
			end
		elseif Object:IsA("BaseScript") then
			Data[holdName]["Disabled"] = Object.Disabled
			Data[holdName]["LinkedSource"] = Object.LinkedSource
		elseif Object:IsA("ModuleScript") then
			Data[holdName]["LinkedSource"] = Object.LinkedSource
		elseif Object:IsA("PackageLink") or Object:IsA("TouchTransmitter") then
			Data[holdName] = nil
			--constraints
		elseif Object:IsA("Constraint") then
			Data[holdName]["Color"] = getProp(Object.Color)
			Data[holdName]["Enabled"] = Object.Enabled
			Data[holdName]["Visible"] = Object.Visible
			--shape
			if Object.Attachment0 then
				Data[holdName]["Attachment0"] = {
					["Location"] = Object.Attachment0:GetFullName();
					["ClassName"] = Object.Attachment0.ClassName;
				}
			end
			if Object.Attachment1 then
				Data[holdName]["Attachment1"] = {
					["Location"] = Object.Attachment1:GetFullName();
					["ClassName"] = Object.Attachment1.ClassName;
				}
			end
			if Object:IsA("AlignOrientation") then
				Data[holdName]["AlignType"] = getProp(Object.AlignType)
				Data[holdName]["CFrame"] = getProp(Object.CFrame)
				Data[holdName]["MaxAngularVelocity"] = Object.MaxAngularVelocity
				Data[holdName]["MaxTorque"] = Object.MaxTorque
				Data[holdName]["Mode"] = getProp(Object.Mode)
				Data[holdName]["PrimaryAxis"] = getProp(Object.PrimaryAxis)
				Data[holdName]["PrimaryAxisOnly"] = Object.PrimaryAxisOnly
				Data[holdName]["ReactionTorqueEnabled"] = Object.ReactionTorqueEnabled
				Data[holdName]["Responsiveness"] = Object.Responsiveness
				Data[holdName]["RigidityEnabled"] = Object.RigidityEnabled
				Data[holdName]["SecondaryAxis"] = getProp(Object.SecondaryAxis)
			elseif Object:IsA("AlignPosition") then
				Data[holdName]["ApplyAtCenterOfMass"] = Object.ApplyAtCenterOfMass
				Data[holdName]["MaxForce"] = Object.MaxForce
				Data[holdName]["MaxVelocity"] = Object.MaxVelocity
				Data[holdName]["Mode"] = getProp(Object.Mode)
				Data[holdName]["Position"] = getProp(Object.Position)
				Data[holdName]["ReactionForceEnabled"] = Object.ReactionForceEnabled
				Data[holdName]["Responsiveness"] = Object.Responsiveness
				Data[holdName]["RigidityEnabled"] = Object.RigidityEnabled
			elseif Object:IsA("AngularVelocity") then
				Data[holdName]["AngularVelocity"] = getProp(Object.AngularVelocity)
				Data[holdName]["MaxTorque"] = Object.MaxTorque
				Data[holdName]["ReactionTorqueEnabled"] = Object.ReactionTorqueEnabled
				Data[holdName]["RelativeTo"] = getProp(Object.RelativeTo)
			elseif Object:IsA("BallSocketConstraint") then
				Data[holdName]["LimitsEnabled"] = Object.LimitsEnabled
				Data[holdName]["MaxFrictionTorque"] = Object.MaxFrictionTorque
				Data[holdName]["Radius"] = Object.Radius
				Data[holdName]["Restitution"] = Object.Restitution
				Data[holdName]["TwistLimitsEnabled"] = Object.TwistLimitsEnabled
				Data[holdName]["TwistLowerAngle"] = Object.TwistLowerAngle
				Data[holdName]["TwistUpperAngle"] = Object.TwistUpperAngle
				Data[holdName]["UpperAngle"] = Object.UpperAngle
			elseif Object:IsA("SlidingBallConstraint") then
				Data[holdName]["ActuatorType"] = getProp(Object.ActuatorType)
				Data[holdName]["LimitsEnabled"] = Object.LimitsEnabled
				Data[holdName]["LinearResponsiveness"] = Object.LinearResponsiveness
				Data[holdName]["MotorMaxAcceleration"] = Object.MotorMaxAcceleration
				Data[holdName]["MotorMaxForce"] = Object.MotorMaxForce
				Data[holdName]["Restitution"] = Object.Restitution
				Data[holdName]["ServoMaxForce"] = Object.ServoMaxForce
				Data[holdName]["Size"] = Object.Size
				Data[holdName]["Speed"] = Object.Speed
				Data[holdName]["TargetPosition"] = Object.TargetPosition
				Data[holdName]["UpperLimit"] = Object.UpperLimit
				Data[holdName]["Velocity"] = Object.Velocity
				if Object:IsA("CylindricalConstraint") then
					Data[holdName]["AngularActuatorType"] = getProp(Object.AngularActuatorType)
					Data[holdName]["AngularLimitsEnabled"] = Object.AngularLimitsEnabled
					Data[holdName]["AngularResponsiveness"] = Object.AngularResponsiveness
					Data[holdName]["AngularRestitution"] = Object.AngularRestitution
					Data[holdName]["AngularSpeed"] = Object.AngularSpeed
					Data[holdName]["AngularVelocity"] = Object.AngularVelocity
					Data[holdName]["InclinationAngle"] = Object.InclinationAngle
					Data[holdName]["LowerAngle"] = Object.LowerAngle
					Data[holdName]["MotorMaxAngularAcceleration"] = Object.MotorMaxAngularAcceleration
					Data[holdName]["MotorMaxTorque"] = Object.MotorMaxTorque
					Data[holdName]["RotationAxisVisible"] = Object.RotationAxisVisible
					Data[holdName]["ServoMaxTorque"] = Object.ServoMaxTorque
					Data[holdName]["TargetAngle"] = Object.TargetAngle
					Data[holdName]["UpperAngle"] = Object.UpperAngle
				end
			elseif Object:IsA("HingeConstraint") then
				Data[holdName]["ActuatorType"] = getProp(Object.ActuatorType)
				Data[holdName]["AngularResponsiveness"] = Object.AngularResponsiveness
				Data[holdName]["AngularSpeed"] = Object.AngularSpeed
				Data[holdName]["AngularVelocity"] = Object.AngularVelocity
				Data[holdName]["LimitsEnabled"] = Object.LimitsEnabled
				Data[holdName]["LowerAngle"] = Object.LowerAngle
				Data[holdName]["MotorMaxAcceleration"] = Object.MotorMaxAcceleration
				Data[holdName]["MotorMaxTorque"] = Object.MotorMaxTorque
				Data[holdName]["Radius"] = Object.Radius
				Data[holdName]["Restitution"] = Object.Restitution
				Data[holdName]["ServoMaxTorque"] = Object.ServoMaxTorque
				Data[holdName]["TargetAngle"] = Object.TargetAngle
				Data[holdName]["UpperAngle"] = Object.UpperAngle
			elseif Object:IsA("LinearVelocity") then
				Data[holdName]["LineDirection"] = getProp(Object.LineDirection)
				Data[holdName]["LineVelocity"] = Object.LineVelocity
				Data[holdName]["MaxForce"] = Object.MaxForce
				Data[holdName]["PlaneVelocity"] = getProp(Object.PlaneVelocity)
				Data[holdName]["PrimaryTangentAxis"] = getProp(Object.PrimaryTangentAxis)
				Data[holdName]["RelativeTo"] = getProp(Object.RelativeTo)
				Data[holdName]["SecondaryTangentAxis"] = getProp(Object.SecondaryTangentAxis)
				Data[holdName]["VectorVelocity"] = getProp(Object.VectorVelocity)
				Data[holdName]["VelocityConstraintMode"] = getProp(Object.VelocityConstraintMode)
			elseif Object:IsA("LineForce") then
				Data[holdName]["ApplyAtCenterOfMass"] = Object.ApplyAtCenterOfMass
				Data[holdName]["InverseSquareLaw"] = Object.InverseSquareLaw
				Data[holdName]["Magnitude"] = Object.Magnitude
				Data[holdName]["MaxForce"] = Object.MaxForce
				Data[holdName]["ReactionForceEnabled"] = Object.ReactionForceEnabled
			elseif Object:IsA("RigidConstraint") then
				Data[holdName]["DestructionEnabled"] = Object.DestructionEnabled
				Data[holdName]["DestructionForce"] = Object.DestructionForce
				Data[holdName]["DestructionTorque"] = Object.DestructionTorque
			elseif Object:IsA("RodConstraint") then
				Data[holdName]["Length"] = Object.Length
				Data[holdName]["LimitAngle0"] = Object.LimitAngle0
				Data[holdName]["LimitAngle1"] = Object.LimitAngle1
				Data[holdName]["LimitsEnabled"] = Object.LimitsEnabled
				Data[holdName]["Thickness"] = Object.Thickness
			elseif Object:IsA("RopeConstraint") then
				Data[holdName]["Length"] = Object.Length
				Data[holdName]["Restitution"] = Object.Restitution
				Data[holdName]["Thickness"] = Object.Thickness
				Data[holdName]["WinchEnabled"] = Object.WinchEnabled
				Data[holdName]["WinchForce"] = Object.WinchForce
				Data[holdName]["WinchResponsiveness"] = Object.WinchResponsiveness
				Data[holdName]["WinchSpeed"] = Object.WinchSpeed
				Data[holdName]["WinchTarget"] = Object.WinchTarget
			elseif Object:IsA("SpringConstraint") then
				Data[holdName]["Coils"] = Object.Coils
				Data[holdName]["Damping"] = Object.Damping
				Data[holdName]["FreeLength"] = Object.FreeLength
				Data[holdName]["LimitsEnabled"] = Object.LimitsEnabled
				Data[holdName]["MaxForce"] = Object.MaxForce
				Data[holdName]["MaxLength"] = Object.MaxLength
				Data[holdName]["MinLength"] = Object.MinLength
				Data[holdName]["Radius"] = Object.Radius
				Data[holdName]["Stiffness"] = Object.Stiffness
				Data[holdName]["Thickness"] = Object.Thickness
			elseif Object:IsA("Torque") then
				Data[holdName]["RelativeTo"] = getProp(Object.RelativeTo)
				Data[holdName]["Torque"] = getProp(Object.Torque)
			elseif Object:IsA("TorsionSpringConstraint") then
				Data[holdName]["Coils"] = Object.Coils
				Data[holdName]["Damping"] = Object.Damping
				Data[holdName]["LimitsEnabled"] = Object.LimitsEnabled
				Data[holdName]["MaxAngle"] = Object.MaxAngle
				Data[holdName]["MaxTorque"] = Object.MaxTorque
				Data[holdName]["Radius"] = Object.Radius
				Data[holdName]["Restitution"] = Object.Restitution
				Data[holdName]["Stiffness"] = Object.Stiffness
			elseif Object:IsA("UniversalConstraint") then
				Data[holdName]["LimitsEnabled"] = Object.LimitsEnabled
				Data[holdName]["MaxAngle"] = Object.MaxAngle
				Data[holdName]["Radius"] = Object.Radius
				Data[holdName]["Restitution"] = Object.Restitution
			elseif Object:IsA("VectorForce") then
				Data[holdName]["ApplyAtCenterOfMass"] = Object.ApplyAtCenterOfMass
				Data[holdName]["Force"] = getProp(Object.Force)
				Data[holdName]["RelativeTo"] = getProp(Object.RelativeTo)
			end
		elseif Object:IsA("NoCollisionConstraint") or Object:IsA("WeldConstraint") then
			Data[holdName]["Enabled"] = Object.Enabled
			--shape
			if Object.Part0 then
				Data[holdName]["Part0"] = {
					["Location"] = Object.Part0:GetFullName();
					["ClassName"] = Object.Part0.ClassName;
				}
			end
			if Object.Part1 then
				Data[holdName]["Part1"] = {
					["Location"] = Object.Part1:GetFullName();
					["ClassName"] = Object.Part1.ClassName;
				}
			end
		elseif Object:IsA("LocalizationTable") then
			Data[holdName]["SourceLocaleId"] = Object.SourceLocaleId
		elseif Object:IsA("GuiBase2d") then
			Data[holdName]["AutoLocalize"] = Object.AutoLocalize
			if Object.RootLocalizationTable then
				Data[holdName]["RootLocalizationTable"] = {
					["Location"] = Object.RootLocalizationTable:GetFullName();
					["ClassName"] = Object.RootLocalizationTable.ClassName;
				}
			end
			if Object:IsA("LayerCollector") then
				Data[holdName]["Enabled"] = Object.Enabled
				Data[holdName]["ResetOnRespawn"] = Object.ResetOnRespawn
				Data[holdName]["ZIndexBehavior"] = getProp(Object.ZIndexBehavior)
				if Object:IsA("ScreenGui") then
					Data[holdName]["DisplayOrder"] = Object.DisplayOrder
					Data[holdName]["IgnoreGuiInset"] = Object.IgnoreGuiInset
				elseif Object:IsA("BillboardGui") then
					Data[holdName]["Active"] = Object.Active
					if Object.Adornee then
						Data[holdName]["Adornee"] = {
							["Location"] = Object.Adornee:GetFullName();
							["ClassName"] = Object.Adornee.ClassName;
						}
					end
					Data[holdName]["AlwaysOnTop"] = Object.AlwaysOnTop
					Data[holdName]["Brightness"] = Object.Brightness
					Data[holdName]["ClipsDescendants"] = Object.ClipsDescendants
					Data[holdName]["DistanceLowerLimit"] = Object.DistanceLowerLimit
					Data[holdName]["DistanceStep"] = Object.DistanceStep
					Data[holdName]["DistanceUpperLimit"] = Object.DistanceUpperLimit
					Data[holdName]["ExtentsOffset"] = getProp(Object.ExtentsOffset)
					Data[holdName]["ExtentsOffsetWorldSpace"] = getProp(Object.ExtentsOffsetWorldSpace)
					Data[holdName]["LightInfluence"] = Object.LightInfluence
					Data[holdName]["MaxDistance"] = Object.MaxDistance
					if Object.PlayerToHideFrom then
						Data[holdName]["PlayerToHideFrom"] = true
					end
					Data[holdName]["Size"] = getProp(Object.Size)
					Data[holdName]["SizeOffset"] = getProp(Object.SizeOffset)
					Data[holdName]["StudsOffset"] = getProp(Object.StudsOffset)
					Data[holdName]["StudsOffsetWorldSpace"] = getProp(Object.StudsOffsetWorldSpace)
				elseif Object:IsA("SurfaceGui") then
					Data[holdName]["Active"] = Object.Active
					if Object.Adornee then
						Data[holdName]["Adornee"] = {
							["Location"] = Object.Adornee:GetFullName();
							["ClassName"] = Object.Adornee.ClassName;
						}
					end
					Data[holdName]["AlwaysOnTop"] = Object.AlwaysOnTop
					Data[holdName]["Brightness"] = Object.Brightness
					Data[holdName]["CanvasSize"] = getProp(Object.CanvasSize)
					Data[holdName]["ClipsDescendants"] = Object.ClipsDescendants
					Data[holdName]["Face"] = getProp(Object.Face)
					Data[holdName]["LightInfluence"] = Object.LightInfluence
					Data[holdName]["PixelsPerStud"] = Object.PixelsPerStud
					Data[holdName]["SizingMode"] = getProp(Object.SizingMode)
					Data[holdName]["ToolPunchThroughDistance"] = Object.ToolPunchThroughDistance
					Data[holdName]["ZOffset"] = Object.ZOffset
				end
			elseif Object:IsA("GuiObject") then
				Data[holdName]["Active"] = Object.Active
				Data[holdName]["AnchorPoint"] = getProp(Object.AnchorPoint)
				Data[holdName]["AutomaticSize"] = getProp(Object.AutomaticSize)
				Data[holdName]["BackgroundColor3"] = getProp(Object.BackgroundColor3)
				Data[holdName]["BackgroundTransparency"] = Object.BackgroundTransparency
				Data[holdName]["BorderColor3"] = getProp(Object.BorderColor3)
				Data[holdName]["BorderMode"] = getProp(Object.BorderMode)
				Data[holdName]["BorderSizePixel"] = Object.BorderSizePixel
				Data[holdName]["ClipsDescendants"] = Object.ClipsDescendants
				Data[holdName]["LayoutOrder"] = Object.LayoutOrder
				if Object.NextSelectionDown then
					Data[holdName]["NextSelectionDown"] = {
						["Location"] = Object.NextSelectionDown:GetFullName();
						["ClassName"] = Object.NextSelectionDown.ClassName;
					}
				end
				if Object.NextSelectionLeft then
					Data[holdName]["NextSelectionLeft"] = {
						["Location"] = Object.NextSelectionLeft:GetFullName();
						["ClassName"] = Object.NextSelectionLeft.ClassName;
					}
				end
				if Object.NextSelectionRight then
					Data[holdName]["NextSelectionRight"] = {
						["Location"] = Object.NextSelectionRight:GetFullName();
						["ClassName"] = Object.NextSelectionRight.ClassName;
					}
				end
				if Object.NextSelectionUp then
					Data[holdName]["NextSelectionUp"] = {
						["Location"] = Object.NextSelectionUp:GetFullName();
						["ClassName"] = Object.NextSelectionUp.ClassName;
					}
				end
				Data[holdName]["Position"] = getProp(Object.Position)
				Data[holdName]["Rotation"] = Object.Rotation
				Data[holdName]["Selectable"] = Object.Selectable
				if Object.SelectionImageObject then
					Data[holdName]["SelectionImageObject"] = {
						["Location"] = Object.SelectionImageObject:GetFullName();
						["ClassName"] = Object.SelectionImageObject.ClassName;
					}
				end
				Data[holdName]["Size"] = getProp(Object.Size)
				Data[holdName]["SizeConstraint"] = getProp(Object.SizeConstraint)
				Data[holdName]["Transparency"] = Object.Transparency
				Data[holdName]["Visible"] = Object.Visible
				Data[holdName]["ZIndex"] = Object.ZIndex
				if Object:IsA("Frame") then
					Data[holdName]["Style"] = getProp(Object.Style)
				elseif Object:IsA("ScrollingFrame") then
					Data[holdName]["AutomaticCanvasSize"] = getProp(Object.AutomaticCanvasSize)
					Data[holdName]["BottomImage"] = Object.BottomImage
					Data[holdName]["CanvasPosition"] = getProp(Object.CanvasPosition)
					Data[holdName]["CanvasSize"] = getProp(Object.CanvasSize)
					Data[holdName]["ElasticBehavior"] = getProp(Object.ElasticBehavior)
					Data[holdName]["HorizontalScrollBarInset"] = getProp(Object.HorizontalScrollBarInset)
					Data[holdName]["MidImage"] = Object.MidImage
					Data[holdName]["ScrollBarImageColor3"] = getProp(Object.ScrollBarImageColor3)
					Data[holdName]["ScrollBarImageTransparency"] = Object.ScrollBarImageTransparency
					Data[holdName]["ScrollBarThickness"] = Object.ScrollBarThickness
					Data[holdName]["ScrollVelocity"] = getProp(Object.ScrollVelocity)
					Data[holdName]["ScrollingDirection"] = getProp(Object.ScrollingDirection)
					Data[holdName]["ScrollingEnabled"] = Object.ScrollingEnabled
					Data[holdName]["TopImage"] = Object.TopImage
					Data[holdName]["VerticalScrollBarInset"] = getProp(Object.VerticalScrollBarInset)
					Data[holdName]["VerticalScrollBarPosition"] = getProp(Object.VerticalScrollBarPosition)
				elseif Object:IsA("TextLabel") or Object:IsA("TextButton") then
					Data[holdName]["Font"] = getProp(Object.Font)
					Data[holdName]["LineHeight"] = Object.LineHeight
					Data[holdName]["MaxVisibleGraphemes"] = Object.MaxVisibleGraphemes
					Data[holdName]["RichText"] = Object.RichText
					Data[holdName]["Text"] = Object.Text
					Data[holdName]["TextColor3"] = getProp(Object.TextColor3)
					Data[holdName]["TextScaled"] = Object.TextScaled
					Data[holdName]["TextSize"] = Object.TextSize
					Data[holdName]["TextStrokeColor3"] = getProp(Object.TextStrokeColor3)
					Data[holdName]["TextStrokeTransparency"] = Object.TextStrokeTransparency
					Data[holdName]["TextTransparency"] = Object.TextTransparency
					Data[holdName]["TextTruncate"] = getProp(Object.TextTruncate)
					Data[holdName]["TextWrapped"] = Object.TextWrapped
					Data[holdName]["TextXAlignment"] = getProp(Object.TextXAlignment)
					Data[holdName]["TextYAlignment"] = getProp(Object.TextYAlignment)
				elseif Object:IsA("TextBox") then
					Data[holdName]["ClearTextOnFocus"] = Object.ClearTextOnFocus
					Data[holdName]["CursorPosition"] = Object.CursorPosition
					Data[holdName]["Font"] = getProp(Object.Font)
					Data[holdName]["LineHeight"] = Object.LineHeight
					Data[holdName]["MaxVisibleGraphemes"] = Object.MaxVisibleGraphemes
					Data[holdName]["MultiLine"] = Object.MultiLine
					Data[holdName]["PlaceholderColor3"] = getProp(Object.PlaceholderColor3)
					Data[holdName]["RichText"] = Object.RichText
					Data[holdName]["SelectionStart"] = Object.SelectionStart
					Data[holdName]["ShowNativeInput"] = Object.ShowNativeInput
					Data[holdName]["Text"] = Object.Text
					Data[holdName]["TextColor3"] = getProp(Object.TextColor3)
					Data[holdName]["TextEditable"] = Object.TextEditable
					Data[holdName]["TextScaled"] = Object.TextScaled
					Data[holdName]["TextSize"] = Object.TextSize
					Data[holdName]["TextStrokeColor3"] = getProp(Object.TextStrokeColor3)
					Data[holdName]["TextStrokeTransparency"] = Object.TextStrokeTransparency
					Data[holdName]["TextTransparency"] = Object.TextTransparency
					Data[holdName]["TextTruncate"] = getProp(Object.TextTruncate)
					Data[holdName]["TextWrapped"] = Object.TextWrapped
					Data[holdName]["TextXAlignment"] = getProp(Object.TextXAlignment)
					Data[holdName]["TextYAlignment"] = getProp(Object.TextYAlignment)
				elseif Object:IsA("ImageLabel") then
					Data[holdName]["Image"] = Object.Image
					Data[holdName]["ImageColor3"] = getProp(Object.ImageColor3)
					Data[holdName]["ImageRectOffset"] = getProp(Object.ImageRectOffset)
					Data[holdName]["ImageRectSize"] = getProp(Object.ImageRectSize)
					Data[holdName]["ImageTransparency"] = Object.ImageTransparency
					Data[holdName]["ResampleMode"] = getProp(Object.ResampleMode)
					Data[holdName]["ScaleType"] = getProp(Object.ScaleType)
					Data[holdName]["SliceCenter"] = getProp(Object.SliceCenter)
					Data[holdName]["SliceScale"] = Object.SliceScale
					Data[holdName]["TileSize"] = getProp(Object.TileSize)
				elseif Object:IsA("ImageButton") then
					Data[holdName]["HoverImage"] = Object.HoverImage
					Data[holdName]["Image"] = Object.Image
					Data[holdName]["ImageColor3"] = getProp(Object.ImageColor3)
					Data[holdName]["ImageRectOffset"] = getProp(Object.ImageRectOffset)
					Data[holdName]["ImageRectSize"] = getProp(Object.ImageRectSize)
					Data[holdName]["ImageTransparency"] = Object.ImageTransparency
					Data[holdName]["PressedImage"] = Object.PressedImage
					Data[holdName]["ResampleMode"] = getProp(Object.ResampleMode)
					Data[holdName]["ScaleType"] = getProp(Object.ScaleType)
					Data[holdName]["SliceCenter"] = getProp(Object.SliceCenter)
					Data[holdName]["SliceScale"] = Object.SliceScale
					Data[holdName]["TileSize"] = getProp(Object.TileSize)
				elseif Object:IsA("ViewportFrame") then
					Data[holdName]["Ambient"] = getProp(Object.Ambient)
					if Object.CurrentCamera then
						Data[holdName]["CurrentCamera"] = {}
						saveParts(Object.CurrentCamera, Data[holdName]["CurrentCamera"])
					end
					Data[holdName]["ImageColor3"] = getProp(Object.ImageColor3)
					Data[holdName]["ImageTransparency"] = Object.ImageTransparency
					Data[holdName]["LightColor"] = getProp(Object.LightColor)
					Data[holdName]["LightDirection"] = getProp(Object.LightDirection)
				elseif Object:IsA("VideoFrame") then
					Data[holdName]["Looped"] = Object.Looped
					Data[holdName]["Playing"] = Object.Playing
					Data[holdName]["TimePosition"] = Object.TimePosition
					Data[holdName]["Video"] = Object.Video
					Data[holdName]["Volume"] = Object.Volume
				end
			end
		elseif Object:IsA("GuiBase3d") then
			Data[holdName]["Color3"] = getProp(Object.Color3)
			Data[holdName]["Transparency"] = Object.Transparency
			Data[holdName]["Visible"] = Object.Visible
			if Object:IsA("PartAdornment") then
				if Object.Adornee then
					Data[holdName]["Adornee"] = {
						["Location"] = Object.Adornee:GetFullName();
						["ClassName"] = Object.Adornee.ClassName;
					}
				end
				if Object:IsA("ArcHandles") then
					Data[holdName]["Axes"] = getProp(Object.Axes)
				elseif Object:IsA("Handles") then
					Data[holdName]["Faces"] = getProp(Object.Faces)
					Data[holdName]["Style"] = getProp(Object.Style)
				elseif Object:IsA("SurfaceSelection") then
					Data[holdName]["TargetSurface"] = getProp(Object.TargetSurface)
				end
			elseif Object:IsA("PVAdornment") then
				if Object.Adornee then
					Data[holdName]["Adornee"] = {
						["Location"] = Object.Adornee:GetFullName();
						["ClassName"] = Object.Adornee.ClassName;
					}
				end
				if Object:IsA("HandleAdornment") then
					Data[holdName]["AdornCullingMode"] = getProp(Object.AdornCullingMode)
					Data[holdName]["AlwaysOnTop"] = Object.AlwaysOnTop
					Data[holdName]["CFrame"] = getProp(Object.CFrame)
					Data[holdName]["SizeRelativeOffset"] = getProp(Object.SizeRelativeOffset)
					Data[holdName]["ZIndex"] = Object.ZIndex
					if Object:IsA("BoxHandleAdornment") then
						Data[holdName]["Size"] = getProp(Object.Size)
					elseif Object:IsA("ConeHandleAdornment") then
						Data[holdName]["Height"] = Object.Height
						Data[holdName]["Radius"] = Object.Radius
					elseif Object:IsA("CylinderHandleAdornment") then
						Data[holdName]["Angle"] = Object.Angle
						Data[holdName]["Height"] = Object.Height
						Data[holdName]["InnerRadius"] = Object.InnerRadius
						Data[holdName]["Radius"] = Object.Radius
					elseif Object:IsA("ImageHandleAdornment") then
						Data[holdName]["Image"] = Object.Image
						Data[holdName]["Size"] = getProp(Object.Size)
					elseif Object:IsA("LineHandleAdornment") then
						Data[holdName]["Length"] = Object.Length
						Data[holdName]["Thickness"] = Object.Thickness
					elseif Object:IsA("SphereHandleAdornment") then
						Data[holdName]["Radius"] = Object.Radius
					end
				elseif Object:IsA("SelectionSphere") then
					Data[holdName]["SurfaceColor3"] = getProp(Object.SurfaceColor3)
					Data[holdName]["SurfaceTransparency"] = Object.SurfaceTransparency
				end
			elseif Object:IsA("SelectionBox") then
				Data[holdName]["LineThickness"] = Object.LineThickness
				Data[holdName]["SurfaceColor3"] = getProp(Object.SurfaceColor3)
				Data[holdName]["SurfaceTransparency"] = Object.SurfaceTransparency
			end
		elseif Object:IsA("PathfindingLink") then
			if Object.Attachment0 then
				Data[holdName]["Attachment0"] = {
					["Location"] = Object.Attachment0:GetFullName();
					["ClassName"] = Object.Attachment0.ClassName;
				}
			end
			if Object.Attachment1 then
				Data[holdName]["Attachment1"] = {
					["Location"] = Object.Attachment1:GetFullName();
					["ClassName"] = Object.Attachment1.ClassName;
				}
			end
			Data[holdName]["IsBidirectional"] = Object.IsBidirectional
			Data[holdName]["Label"] = Object.Label
		elseif Object:IsA("PathfindingModifier") then
			Data[holdName]["Label"] = Object.Label
			Data[holdName]["PassThrough"] = Object.PassThrough
		elseif Object:IsA("UIAspectRatioConstraint") then
			Data[holdName]["AspectRatio"] = Object.AspectRatio
			Data[holdName]["AspectType"] = getProp(Object.AspectType)
			Data[holdName]["DominantAxis"] = getProp(Object.DominantAxis)
		elseif Object:IsA("UICorner") then
			Data[holdName]["CornerRadius"] = getProp(Object.CornerRadius)
		elseif Object:IsA("UIGradient") then
			Data[holdName]["Color"] = getProp(Object.Color)
			Data[holdName]["Enabled"] = Object.Enabled
			Data[holdName]["Offset"] = getProp(Object.Offset)
			Data[holdName]["Rotation"] = Object.Rotation
			Data[holdName]["Transparency"] = getProp(Object.Transparency)
		elseif Object:IsA("UIGridStyleLayout") then
			Data[holdName]["FillDirection"] = getProp(Object.FillDirection)
			Data[holdName]["HorizontalAlignment"] = getProp(Object.HorizontalAlignment)
			Data[holdName]["SortOrder"] = getProp(Object.SortOrder)
			Data[holdName]["VerticalAlignment"] = getProp(Object.VerticalAlignment)
			if Object:IsA("UIGridLayout") then
				Data[holdName]["CellPadding"] = getProp(Object.CellPadding)
				Data[holdName]["CellSize"] = getProp(Object.CellSize)
				Data[holdName]["FillDirectionMaxCells"] = Object.FillDirectionMaxCells
				Data[holdName]["StartCorner"] = getProp(Object.StartCorner)
			elseif Object:IsA("UIListLayout") then
				Data[holdName]["Padding"] = getProp(Object.Padding)
			elseif Object:IsA("UIPageLayout") then
				Data[holdName]["Animated"] = Object.Animated
				Data[holdName]["Circular"] = Object.Circular
				Data[holdName]["EasingDirection"] = getProp(Object.EasingDirection)
				Data[holdName]["EasingStyle"] = getProp(Object.EasingStyle)
				Data[holdName]["GamepadInputEnabled"] = Object.GamepadInputEnabled
				Data[holdName]["Padding"] = getProp(Object.Padding)
				Data[holdName]["ScrollWheelInputEnabled"] = Object.ScrollWheelInputEnabled
				Data[holdName]["TouchInputEnabled"] = Object.TouchInputEnabled
				Data[holdName]["TweenTime"] = Object.TweenTime
			elseif Object:IsA("UITableLayout") then
				Data[holdName]["FillEmptySpaceColumns"] = Object.FillEmptySpaceColumns
				Data[holdName]["FillEmptySpaceRows"] = Object.FillEmptySpaceRows
				Data[holdName]["MajorAxis"] = getProp(Object.MajorAxis)
				Data[holdName]["Padding"] = getProp(Object.Padding)
			end
		elseif Object:IsA("UIPadding") then
			Data[holdName]["PaddingBottom"] = getProp(Object.PaddingBottom)
			Data[holdName]["PaddingLeft"] = getProp(Object.PaddingLeft)
			Data[holdName]["PaddingRight"] = getProp(Object.PaddingRight)
			Data[holdName]["PaddingTop"] = getProp(Object.PaddingTop)
		elseif Object:IsA("UIScale") then
			Data[holdName]["Scale"] = Object.Scale
		elseif Object:IsA("UISizeConstraint") then
			Data[holdName]["MaxSize"] = getProp(Object.MaxSize)
			Data[holdName]["MinSize"] = getProp(Object.MinSize)
		elseif Object:IsA("UIStroke") then
			Data[holdName]["ApplyStrokeMode"] = getProp(Object.ApplyStrokeMode)
			Data[holdName]["Color"] = getProp(Object.Color)
			Data[holdName]["Enabled"] = Object.Enabled
			Data[holdName]["LineJoinMode"] = getProp(Object.LineJoinMode)
			Data[holdName]["Thickness"] = Object.Thickness
			Data[holdName]["Transparency"] = Object.Transparency
		elseif Object:IsA("UITextSizeConstraint") then
			Data[holdName]["MaxTextSize"] = Object.MaxTextSize
			Data[holdName]["MinTextSize"] = Object.MinTextSize
		end

		local children = Object:GetChildren()
		if #children > 0 then
			Data[holdName]["Children"] = {}
			for i, v in pairs(children) do
				saveParts(v, Data[holdName]["Children"], i)
			end
		end
		return HttpService:JSONEncode(Data)
	else
		return false
	end
end


-- Gui to Lua
-- Version: 3.2

-- Instances:

local Main = Instance.new("ScreenGui")
local Mainframe = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local UICorner = Instance.new("UICorner")
local CloseButton = Instance.new("ImageButton")
local SavePlot = Instance.new("TextButton")
local UICorner_2 = Instance.new("UICorner")
local LoadPlot = Instance.new("TextButton")
local UICorner_3 = Instance.new("UICorner")
local Pattern = Instance.new("ImageLabel")
local CurrentPlot = Instance.new("TextLabel")
local Username = Instance.new("TextBox")
local UICorner_4 = Instance.new("UICorner")
local SaveFile = Instance.new("TextBox")
local UICorner_5 = Instance.new("UICorner")
local TextLabel = Instance.new("TextLabel")

--Properties:

Main.Name = "Main"
Main.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
Main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Main.ResetOnSpawn = false

Mainframe.Name = "Mainframe"
Mainframe.Parent = Main
Mainframe.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Mainframe.ClipsDescendants = true
Mainframe.Position = UDim2.new(0.5, -147, 0.5, -232)
Mainframe.Size = UDim2.new(0, 294, 0, 464)

Title.Name = "Title"
Title.Parent = Mainframe
Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1.000
Title.Position = UDim2.new(0.0272108838, 0, 0, 0)
Title.Size = UDim2.new(0, 255, 0, 31)
Title.ZIndex = 3
Title.Font = Enum.Font.RobotoMono
Title.Text = "PlotCopy v1 | sashaa#5351"
Title.TextColor3 = Color3.fromRGB(255, 131, 43)
Title.TextSize = 22.000
Title.TextStrokeTransparency = 0.000
Title.TextWrapped = true

UICorner.Parent = Mainframe

CloseButton.Name = "CloseButton"
CloseButton.Parent = Mainframe
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.BackgroundTransparency = 1.000
CloseButton.Position = UDim2.new(0.894557834, 0, 0, 0)
CloseButton.Size = UDim2.new(0, 31, 0, 31)
CloseButton.ZIndex = 3
CloseButton.Image = "rbxassetid://3926305904"
CloseButton.ImageRectOffset = Vector2.new(164, 164)
CloseButton.ImageRectSize = Vector2.new(36, 36)

SavePlot.Name = "SavePlot"
SavePlot.Parent = Mainframe
SavePlot.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
SavePlot.Position = UDim2.new(0.0884353742, 0, 0.674568892, 0)
SavePlot.Size = UDim2.new(0, 241, 0, 50)
SavePlot.ZIndex = 3
SavePlot.Font = Enum.Font.RobotoMono
SavePlot.Text = "Save Plot To File"
SavePlot.TextColor3 = Color3.fromRGB(255, 189, 35)
SavePlot.TextSize = 27.000

UICorner_2.CornerRadius = UDim.new(0, 30)
UICorner_2.Parent = SavePlot

LoadPlot.Name = "LoadPlot"
LoadPlot.Parent = Mainframe
LoadPlot.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
LoadPlot.Position = UDim2.new(0.15646258, 0, 0.256465495, 0)
LoadPlot.Size = UDim2.new(0, 200, 0, 50)
LoadPlot.ZIndex = 3
LoadPlot.Font = Enum.Font.RobotoMono
LoadPlot.Text = "Load Plot"
LoadPlot.TextColor3 = Color3.fromRGB(255, 189, 35)
LoadPlot.TextSize = 27.000

UICorner_3.CornerRadius = UDim.new(0, 30)
UICorner_3.Parent = LoadPlot

Pattern.Name = "Pattern"
Pattern.Parent = Mainframe
Pattern.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Pattern.BackgroundTransparency = 1.000
Pattern.Size = UDim2.new(0, 294, 0, 464)
Pattern.Image = "rbxassetid://121480522"
Pattern.ImageColor3 = Color3.fromRGB(253, 255, 126)
Pattern.ImageTransparency = 0.800
Pattern.ScaleType = Enum.ScaleType.Tile
Pattern.SliceCenter = Rect.new(0, 256, 0, 256)
Pattern.TileSize = UDim2.new(0, 45, 0, 45)

CurrentPlot.Name = "CurrentPlot"
CurrentPlot.Parent = Mainframe
CurrentPlot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CurrentPlot.BackgroundTransparency = 1.000
CurrentPlot.Position = UDim2.new(0.0646258444, 0, 0.135775864, 0)
CurrentPlot.Size = UDim2.new(0, 255, 0, 31)
CurrentPlot.ZIndex = 3
CurrentPlot.Font = Enum.Font.RobotoMono
CurrentPlot.Text = "Plot Found | Placeholder1"
CurrentPlot.TextColor3 = Color3.fromRGB(255, 131, 43)
CurrentPlot.TextScaled = true
CurrentPlot.TextSize = 22.000
CurrentPlot.TextStrokeTransparency = 0.000
CurrentPlot.TextWrapped = true

Username.Name = "Username"
Username.Parent = Mainframe
Username.BackgroundColor3 = Color3.fromRGB(16, 15, 13)
Username.Position = UDim2.new(0.0646258518, 0, 0.387931019, 0)
Username.Size = UDim2.new(0, 255, 0, 50)
Username.Font = Enum.Font.RobotoMono
Username.Text = "Username"
Username.TextColor3 = Color3.fromRGB(255, 243, 243)
Username.TextScaled = true
Username.TextSize = 14.000
Username.TextStrokeColor3 = Color3.fromRGB(78, 17, 116)
Username.TextStrokeTransparency = 0.000
Username.TextWrapped = true

UICorner_4.Parent = Username

SaveFile.Name = "SaveFile"
SaveFile.Parent = Mainframe
SaveFile.BackgroundColor3 = Color3.fromRGB(16, 15, 13)
SaveFile.Position = UDim2.new(0.0646258518, 0, 0.534482718, 0)
SaveFile.Size = UDim2.new(0, 255, 0, 50)
SaveFile.Font = Enum.Font.RobotoMono
SaveFile.Text = "File Name"
SaveFile.TextColor3 = Color3.fromRGB(255, 243, 243)
SaveFile.TextScaled = true
SaveFile.TextSize = 14.000
SaveFile.TextStrokeColor3 = Color3.fromRGB(78, 17, 116)
SaveFile.TextStrokeTransparency = 0.000
SaveFile.TextWrapped = true

UICorner_5.Parent = SaveFile

TextLabel.Parent = Mainframe
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.Position = UDim2.new(0.15646258, 0, 0.821120679, 0)
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "Make sure that you have an empty plot loaded and btools equipped before you load a plot."
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextSize = 14.000
TextLabel.TextWrapped = true

-- Scripts:

local function YLXGEJP_fake_script() -- CloseButton.LocalScript 
	local script = Instance.new('LocalScript', CloseButton)

	local Open = true
	local Tweening = false
	
	script.Parent.MouseButton1Click:Connect(function()
		if Open and not Tweening then
			Tweening = true
			script.Parent.Parent:TweenSize(UDim2.new(0, 294,0, 32),Enum.EasingDirection.Out,Enum.EasingStyle.Quint,0.3)
			for i,v in pairs(script.Parent.Parent:GetChildren()) do
				if (v:IsA("TextBox") or v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("ImageLabel")) and v.Name ~= "Title" then
					v.Visible = false
				end
			end
			wait(0.3)
			Tweening = false
			Open = false
		elseif not Open and not Tweening then
			Tweening = true
			script.Parent.Parent:TweenSize(UDim2.new(0, 294,0, 464),Enum.EasingDirection.Out,Enum.EasingStyle.Quint,0.3)
			for i,v in pairs(script.Parent.Parent:GetChildren()) do
				if (v:IsA("TextBox") or v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("ImageLabel")) and v.Name ~= "Title" then
					v.Visible = true
				end
			end
			wait(0.3)
			Tweening = false
			Open = true
		end
	end)
end
coroutine.wrap(YLXGEJP_fake_script)()
local function DOYS_fake_script() -- Mainframe.DragScript 
	local script = Instance.new('LocalScript', Mainframe)

	local UIS = game:GetService('UserInputService')
	local frame = script.Parent
	local dragToggle = nil
	local dragSpeed = 0.25
	local dragStart = nil
	local startPos = nil
	
	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		game:GetService('TweenService'):Create(frame, TweenInfo.new(dragSpeed), {Position = position}):Play()
	end
	
	frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true
			dragStart = input.Position
			startPos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)
	
	UIS.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end)
	
end
coroutine.wrap(DOYS_fake_script)()



local Notify = function(title, text) 
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = title;
        Text = text;
        Duration = 3;
    })
end

local PrivateBuilds = workspace["Private Building Areas"]
local MyPlot = workspace:FindFirstChild("Private Building Areas"):FindFirstChild(game:GetService("Players").LocalPlayer.Name.."BuildArea")
if MyPlot ~= nil then
    MyPlot = MyPlot.Build
end

local CachedBuilds = {}

local function CreatePart(Position,PartInstance)
    
    local Type = "Normal"

    if PartInstance.ClassName == "WedgePart" then
        Type = "Wedge"
    elseif PartInstance.ClassName == "TrussPart" then
        Type = "Truss"
    elseif PartInstance.ClassName == "CornerWedgePart" then
        Type = "Corner"
    elseif PartInstance.ClassName == "Seat" then
        Type = "Seat"
    elseif PartInstance.ClassName == "VehicleSeat" then
        Type = "VehicleSeat"
    elseif PartInstance.Shape == Enum.PartType.Cylinder then
        Type = "Cylinder"
    elseif PartInstance.Shape == Enum.PartType.Ball then
        Type = "Ball"
    end

    local args = {
        [1] = "CreatePart",
        [2] = Type,
        [3] = Position,
        [4] = MyPlot
    }
    
    local Response = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))

    return Response
end

local function ResizePart(Part,Size)
    if Part ~= nil then
    local args = {
        [1] = "SyncResize",
        [2] = {
            [1] = {
                ["Part"] = Part,
                ["CFrame"] = Part.CFrame,
                ["Size"] = Size
            }
        }
    }
    
    game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))    
    end
end

local function Decalize(Part,Decal)
    local args = {
        [1] = "CreateTextures",
        [2] = {
            [1] = {
                ["Part"] = Part,
                ["Face"] = Decal.Face,
                ["TextureType"] = "Decal"
            }
        }
    }
    
    local Response = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))
    
    local args = {
        [1] = "SyncTexture",
        [2] = {
            [1] = {
                ["Part"] = Part,
                ["Face"] = Decal.Face,
                ["TextureType"] = "Decal",
                ["Texture"] = Decal.Texture,
                ["Transparency"] = Decal.Transparency
            }
        }
    }
    
    game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))
    
end

local function ColorPart(Part,Color)
    if Part ~= nil and Color ~= BrickColor.new("Medium stone grey").Color then
    local args = {
        [1] = "SyncColor",
        [2] = {
            [1] = {
                ["Part"] = Part,
                ["Color"] = Color,
                ["UnionColoring"] = true
            }
        }
    }
    
    game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))
    end
end

local function Meshinate(Part,Mesh)

    local args = {
        [1] = "CreateMeshes",
        [2] = {
            [1] = {
                ["Part"] = Part
            }
        }
    }
    
    game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))
    
    local Response = Part:WaitForChild("SpecialMesh",3)

    if Mesh.MeshType == Enum.MeshType.FileMesh then
        local args = {
            [1] = "SyncMesh",
            [2] = {
                [1] = {
                    ["MeshType"] = Enum.MeshType.FileMesh,
                    ["Part"] = Part,
                    ["Scale"] = Mesh.Scale,
                    ["MeshId"] = Mesh.MeshId,
                    ["TextureId"] = Mesh.TextureId
                }
            }
        }
        
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))
    else
        local args = {
            [1] = "SyncMesh",
            [2] = {
                [1] = {
                    ["MeshType"] = Mesh.MeshType,
                    ["Part"] = Part,
                    ["Scale"] = Mesh.Scale
                }
            }
        }
        
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))
    end

end

local function Lightify(Part,Light)

    local args = {
        [1] = "CreateLights",
        [2] = {
            [1] = {
                ["Part"] = Part,
                ["LightType"] = tostring(Light.ClassName)
            }
        }
    }
    
    local Response = game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))

    if Light.ClassName ~= "PointLight" then

        local args = {
            [1] = "SyncLighting",
            [2] = {
                [1] = {
                    ["Part"] = Part,
                    ["LightType"] = tostring(Light.Name),
                    ["Shadows"] = Light.Shadows,
                    ["Brightness"] = Light.Brightness,
                    ["Color"] = Light.Color,
                    ["Angle"] = Light.Angle,
                    ["Face"] = Light.Face,
                    ["Range"] = Light.Range
                }
            }
        }
        
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))
    else
        local args = {
            [1] = "SyncLighting",
            [2] = {
                [1] = {
                    ["Part"] = Part,
                    ["LightType"] = tostring(Light.Name),
                    ["Shadows"] = Light.Shadows,
                    ["Brightness"] = Light.Brightness,
                    ["Color"] = Light.Color,
                    ["Range"] = Light.Range
                }
            }
        }
        
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))
    end

    
    
end

local function MaterializePart(Part,Material,Transparency,Reflectance)

    --if Reflectance == 0 and Material == Enum.Material.Plastic and Transparency == 0 then

    local args = {
        [1] = "SyncMaterial",
        [2] = {
            [1] = {
                ["Part"] = Part,
                ["Material"] = Material,
                ["Transparency"] = Transparency,
                ["Reflectance"] = Reflectance
            }
        }
    }
    
    game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args))
    
    --end
end

local function Collideify(Part,CanCollide)

    if CanCollide == false then
        local args = {
            [1] = "SyncCollision",
            [2] = {
                [1] = {
                    ["Part"] = Part,
                    ["CanCollide"] = CanCollide
                }
            }
        }
        
        game:GetService("Players").LocalPlayer.Character:FindFirstChild("Building Tools").SyncAPI.ServerEndpoint:InvokeServer(unpack(args)) 
    end
 
end

local Building = false

local function BuildPlot(Folder,CFrame)
    Notify("Loading","Loading plot...")

    Folder = Folder:Clone()

    for _,v in pairs(Folder.Build:GetDescendants()) do
        if v:IsA("BasePart") then
        local Offset = v.CFrame.Position - CFrame.Position
        v.Position = MyPlot.Parent.Position + Offset
        end
    end

    local FolderTable = Folder.Build:GetChildren()

    table.sort(FolderTable,
		function(a, b)
            if a:IsA("BasePart") and b:IsA("BasePart") then
			return a.Size.Magnitude > b.Size.Magnitude
            else
                return true
			end
		end
	)

    -- for _,v in pairs(Folder:GetChildren()) do
    --     v.Transparency = 0.5
    --     v.Parent = workspace
    -- end

    Building = true

    -- task.spawn(function()
    --     while Building do
    --         wait(10)
    --         game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.Text = "!svp "..CurrentPlot
    --         for i,v in pairs(getconnections(game:GetService("Players").LocalPlayer.PlayerGui.Chat.Frame.ChatBarParentFrame.Frame.BoxFrame.Frame.ChatBar.FocusLost)) do
    --             v:Fire(true)
    --         end
    --     end
    -- end)

    Notify("Loaded","Loaded plot!")

    task.wait(1)

    Notify("Building","Building plot!")

    for i,v in ipairs(FolderTable) do
        pcall(function()
        if v:IsA("BasePart") then
            task.wait(0.03)

            local P = CreatePart(v.CFrame,v)

            Collideify(P,v.CanCollide)
            ResizePart(P,v.Size)
            ColorPart(P,v.Color)
            MaterializePart(P,v.Material,v.Transparency,v.Reflectance)

            if v:FindFirstChild("Decal") then
                Decalize(P,v.Decal)
            end

            if v:FindFirstChildOfClass("SpecialMesh") then
                Meshinate(P,v.Mesh)
            end
            if v:FindFirstChildOfClass("SurfaceLight") then
                Lightify(P,v:FindFirstChildOfClass("SurfaceLight"))
            end
            if v:FindFirstChildOfClass("PointLight") then
                Lightify(P,v:FindFirstChildOfClass("PointLight"))
            end
            if v:FindFirstChildOfClass("SpotLight") then
                Lightify(P,v:FindFirstChildOfClass("SpotLight"))
            end
            Notify("Building...",tostring(i).."/"..tostring(#FolderTable))
        end
        end)
    end

    Notify("Done","Plot built!")

    Building = false
end

local CurrentSelection = ""

Username:GetPropertyChangedSignal("Text"):Connect(function()

    MyPlot = workspace:FindFirstChild("Private Building Areas"):FindFirstChild(game:GetService("Players").LocalPlayer.Name.."BuildArea")
    if MyPlot ~= nil then
        MyPlot = MyPlot.Build
    end
    
    CachedBuilds = {}

    for i,v in pairs(PrivateBuilds:GetChildren()) do
        if not CachedBuilds[v.Name] then
            CachedBuilds[v.Name] = {v:Clone(),v.CFrame}
        end

        CurrentPlot.Text = "No plot found."
        for i,plr in pairs(game.Players:GetChildren()) do
            if plr.Name:lower():match(Username.Text:lower()) then
                CurrentSelection = plr.Name .. "BuildArea"
                CurrentPlot.Text = "Plot found! | " .. CurrentSelection
            end
        end
    end

end)

LoadPlot.MouseButton1Click:Connect(function()
    if CachedBuilds[CurrentSelection] then
        BuildPlot(CachedBuilds[CurrentSelection][1],CachedBuilds[CurrentSelection][2])
    end
end)

-- SavePlot.MouseButton1Click:Connect(function()
--     if CachedBuilds[CurrentSelection] then
--         local ToSave = CachedBuilds[CurrentSelection][1]
--         print(saveAttributes(ToSave))
--         writefile("/PlotCopySaves/",saveAttributes(ToSave))
--     end
-- end)


-- if not isfolder("PlotCopySaves") then
--     makefolder("PlotCopySaves")
-- end
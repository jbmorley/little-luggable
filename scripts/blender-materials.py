"""
Creates a set of plastic materials.

Usage: Blender > Scripting tab > open this file > Run Script.
Then assign a material to an object from the Material Properties tab.
"""

import bpy


def make_plastic(name, base_color, roughness, ior,
                  coat_weight=0.0, coat_roughness=0.15,
                  bump_scale=60.0, bump_strength=0.03,
                  transmission=0.0,
                  subsurface=0.0, subsurface_radius=(1.0, 1.0, 1.0),
                  specular_ior_level=0.5):
    mat = bpy.data.materials.get(name) or bpy.data.materials.new(name)
    mat.use_nodes = True
    nodes = mat.node_tree.nodes
    links = mat.node_tree.links
    nodes.clear()

    bsdf = nodes.new("ShaderNodeBsdfPrincipled")
    bsdf.location = (0, 0)
    bsdf.inputs["Base Color"].default_value = (*base_color, 1.0)
    bsdf.inputs["Roughness"].default_value = roughness
    bsdf.inputs["IOR"].default_value = ior
    bsdf.inputs["Metallic"].default_value = 0.0
    bsdf.inputs["Coat Weight"].default_value = coat_weight
    bsdf.inputs["Coat Roughness"].default_value = coat_roughness
    bsdf.inputs["Transmission Weight"].default_value = transmission
    bsdf.inputs["Subsurface Weight"].default_value = subsurface
    bsdf.inputs["Subsurface Radius"].default_value = subsurface_radius
    bsdf.inputs["Specular IOR Level"].default_value = specular_ior_level

    noise = nodes.new("ShaderNodeTexNoise")
    noise.location = (-500, -200)
    noise.inputs["Scale"].default_value = bump_scale

    bump = nodes.new("ShaderNodeBump")
    bump.location = (-250, -200)
    bump.inputs["Strength"].default_value = bump_strength

    output = nodes.new("ShaderNodeOutputMaterial")
    output.location = (300, 0)

    links.new(noise.outputs["Fac"], bump.inputs["Height"])
    links.new(bump.outputs["Normal"], bsdf.inputs["Normal"])
    links.new(bsdf.outputs["BSDF"], output.inputs["Surface"])
    return mat


# --- Material set ---

make_plastic(
    name="Black_LowGloss_ABS",
    base_color=(0.02, 0.02, 0.02),
    roughness=0.5,
    ior=1.54,
    coat_weight=0.08,
    coat_roughness=0.15,
    bump_scale=60.0,
    bump_strength=0.03,
)

make_plastic(
    name="Grey_Polypropylene_Pelican",
    base_color=(0.30, 0.30, 0.31),   # neutral, very slightly cool grey
    roughness=0.55,                   # PP is a bit softer/less sheen than ABS
    ior=1.49,                         # polypropylene's actual IOR
    coat_weight=0.0,                  # no clearcoat - PP case shells are uncoated
    coat_roughness=0.15,
    bump_scale=25.0,                  # coarser, more visible pebbled texture
    bump_strength=0.08,               # stronger - the grip texture is functional, not subtle
)

make_plastic(
    name="Teal_Translucent_Acrylic",
    base_color=(0.07, 0.36, 0.38),
    roughness=0.55,                   # up from 0.4 - was reading too glossy
    ior=1.49,                         # acrylic
    coat_weight=0.0,
    transmission=0.9,                 # most light passes through
    subsurface=0.25,                  # gives the "glowing from within" plastic look
    subsurface_radius=(0.08, 0.36, 0.38),  # tinted teal, matches base color
    bump_scale=80.0,
    bump_strength=0.015,              # very light - heavy bump on transmissive surfaces looks noisy
    specular_ior_level=0.3,           # down from default 0.5 - cuts highlight intensity independent of roughness
)

make_plastic(
    name="Red_Matte_Plastic_Label",
    base_color=(0.35, 0.02, 0.02),
    roughness=0.5,                    # same matte-ish finish as the ABS body
    ior=1.5,
    coat_weight=0.0,                  # printed/molded label tags are usually uncoated
    bump_scale=80.0,
    bump_strength=0.02,               # small part, keep texture subtle
)

make_plastic(
    name="Black_HighGloss_Injection_Molded",
    base_color=(0.015, 0.015, 0.015),
    roughness=0.08,                   # near-mirror - this is what makes it read as "high gloss"
    ior=1.55,
    coat_weight=0.15,                 # thin lacquer-like top layer, typical of piano-black parts
    coat_roughness=0.03,
    bump_scale=100.0,
    bump_strength=0.0,                # smooth - any visible texture kills the high-gloss look
)

make_plastic(
    name="Black_Rubber_Gasket",
    base_color=(0.015, 0.015, 0.015),
    roughness=0.85,                   # fully diffuse, no visible highlight shape
    ior=1.5,
    coat_weight=0.0,
    bump_scale=50.0,
    bump_strength=0.04,               # slight texture from the mold, not smooth like the hard plastics
    specular_ior_level=0.15,          # rubber barely reflects - lower than any plastic here
)

make_plastic(
    name="Black_Smokey_Translucent",
    base_color=(0.16, 0.16, 0.18),    # lightened again - still reading too solid
    roughness=0.1,                    # glossy surface, same family as the high-gloss part
    ior=1.52,
    coat_weight=0.12,
    coat_roughness=0.04,
    transmission=0.95,                # up from 0.85 - was reading too opaque
    bump_scale=100.0,
    bump_strength=0.0,                # smooth surface, same reasoning as the high-gloss black
    specular_ior_level=0.5,
)

MATERIAL_NAMES = (
    "Black_LowGloss_ABS",
    "Grey_Polypropylene_Pelican",
    "Teal_Translucent_Acrylic",
    "Red_Matte_Plastic_Label",
    "Black_HighGloss_Injection_Molded",
    "Black_Rubber_Gasket",
    "Black_Smokey_Translucent",
)
print("Materials created:", [m.name for m in bpy.data.materials
                              if m.name in MATERIAL_NAMES])

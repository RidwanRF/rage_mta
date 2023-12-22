function unloadShaders()
	for k,v in pairs(getElementsByType('shader', resourceRoot)) do
		destroyElement(v)
	end
	for k,v in pairs(getElementsByType('texture', resourceRoot)) do
		destroyElement(v)
	end
end


trava = {
	"desgreengrass",

}

skala = {
	
	

}

skala2 = {
	

}

road = {
	"cw2_mounttrail",

}

function loadShaders()
		-- local texture = dxCreateTexture("img/trava.dds")
		-- local shader = dxCreateShader("shader.fx")
		-- dxSetShaderValue(shader, "gTexture", texture)

		-- for k, v in ipairs(trava) do
		-- 	engineApplyShaderToWorldTexture(shader, v)
		-- end

		-- local texture = dxCreateTexture("img/skala.dds")
		-- local shader = dxCreateShader("shader.fx")
		-- dxSetShaderValue(shader, "gTexture", texture)

		-- for k, v in ipairs(skala) do
		-- 	engineApplyShaderToWorldTexture(shader, v)
		-- end

		-- local texture = dxCreateTexture("img/skala2.dds")
		-- local shader = dxCreateShader("shader.fx")
		-- dxSetShaderValue(shader, "gTexture", texture)

		-- for k, v in ipairs(skala2) do
		-- 	engineApplyShaderToWorldTexture(shader, v)
		-- end

		-- local texture = dxCreateTexture("img/road.dds")
		-- local shader = dxCreateShader("shader.fx")
		-- dxSetShaderValue(shader, "gTexture", texture)

		-- for k, v in ipairs(road) do
		-- 	engineApplyShaderToWorldTexture(shader, v)
		-- end

		-- local texture = dxCreateTexture("img/rock.dds")
		-- local shader = dxCreateShader("shader.fx")
		-- dxSetShaderValue(shader, "gTexture", texture)
		--engineApplyShaderToWorldTexture(shader, "rocktq128")

		local texture = dxCreateTexture("img/5.png")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "headlight")

		-- ПЕСОК

		local texture = dxCreateTexture("img/des_dirt1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "des_dirt1")
		engineApplyShaderToWorldTexture(shader, "sw_sand")
		engineApplyShaderToWorldTexture(shader, "des_ripplsand")
		engineApplyShaderToWorldTexture(shader, "ws_drysand")
		engineApplyShaderToWorldTexture(shader, "ws_wetdryblendsand")
		engineApplyShaderToWorldTexture(shader, "ws_wetsand")
		engineApplyShaderToWorldTexture(shader, "sandnew_law")
		engineApplyShaderToWorldTexture(shader, "sandstonemixb")
		engineApplyShaderToWorldTexture(shader, "des_dirtgravel")
		engineApplyShaderToWorldTexture(shader, "des_scrub1_dirt1b")
		engineApplyShaderToWorldTexture(shader, "des_dirt1_glfhvy")

		-- ТРАВА

		local texture = dxCreateTexture("img/des_scrub1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "des_scrub1")
		engineApplyShaderToWorldTexture(shader, "bow_church_grass_gen")
		engineApplyShaderToWorldTexture(shader, "desgrasandblend")
		engineApplyShaderToWorldTexture(shader, "desgreengrass")
		engineApplyShaderToWorldTexture(shader, "des_grass2scrub")
		engineApplyShaderToWorldTexture(shader, "desgreengrassmix")
		engineApplyShaderToWorldTexture(shader, "desgreengrassmix")
		engineApplyShaderToWorldTexture(shader, "sw_grass01a")
		engineApplyShaderToWorldTexture(shader, "sw_grass01")
		engineApplyShaderToWorldTexture(shader, "desgrassbrn")
		engineApplyShaderToWorldTexture(shader, "grasstype5")
		engineApplyShaderToWorldTexture(shader, "grasstype5")
		engineApplyShaderToWorldTexture(shader, "grassdead1")
		engineApplyShaderToWorldTexture(shader, "grassdry_128hv")
		engineApplyShaderToWorldTexture(shader, "bow_grass_gryard")
		engineApplyShaderToWorldTexture(shader, "grass_128hv")
		engineApplyShaderToWorldTexture(shader, "yardgrass1")
		engineApplyShaderToWorldTexture(shader, "grass")
		engineApplyShaderToWorldTexture(shader, "grassgrnbrn256")
		engineApplyShaderToWorldTexture(shader, "des_dirtgrassmixbmp")
		engineApplyShaderToWorldTexture(shader, "des_dirtgrassmixb")
		engineApplyShaderToWorldTexture(shader, "grassdeadbrn256")
		engineApplyShaderToWorldTexture(shader, "grasstype4")
		engineApplyShaderToWorldTexture(shader, "des_dirtgrassmix_grass4")
		engineApplyShaderToWorldTexture(shader, "grass4dirty")
		engineApplyShaderToWorldTexture(shader, "forestfloor256")
		engineApplyShaderToWorldTexture(shader, "forestfloorblendded")
		engineApplyShaderToWorldTexture(shader, "forestfloor3_forest")
		engineApplyShaderToWorldTexture(shader, "forestfloor3")
		engineApplyShaderToWorldTexture(shader, "grasstype4_forestblend")
		engineApplyShaderToWorldTexture(shader, "forestfloorbranch256")
		engineApplyShaderToWorldTexture(shader, "grasstype4_mudblend")
		engineApplyShaderToWorldTexture(shader, "grasstype5_4")
		engineApplyShaderToWorldTexture(shader, "desgrassbrn_grn")
		engineApplyShaderToWorldTexture(shader, "desertgryard256")
		engineApplyShaderToWorldTexture(shader, "grassdead1blnd")
		engineApplyShaderToWorldTexture(shader, "grasstype3")
		engineApplyShaderToWorldTexture(shader, "grassdeep256")
		engineApplyShaderToWorldTexture(shader, "grassshort2long256")
		engineApplyShaderToWorldTexture(shader, "forestfloorgrass")
		engineApplyShaderToWorldTexture(shader, "grasstype10")
		engineApplyShaderToWorldTexture(shader, "grassdeep1")
		engineApplyShaderToWorldTexture(shader, "grass10_grassdeep1")
		engineApplyShaderToWorldTexture(shader, "grasstype510_10")
		engineApplyShaderToWorldTexture(shader, "grasstype510")
		engineApplyShaderToWorldTexture(shader, "dirt64b2")
		engineApplyShaderToWorldTexture(shader, "golf_heavygrass")
		engineApplyShaderToWorldTexture(shader, "golf_fairway2")
		engineApplyShaderToWorldTexture(shader, "golf_fairway1")
		engineApplyShaderToWorldTexture(shader, "desmud")
		engineApplyShaderToWorldTexture(shader, "grassgrn256")
		engineApplyShaderToWorldTexture(shader, "grasstype4-3")
		engineApplyShaderToWorldTexture(shader, "sw_rockgrassb2")
		engineApplyShaderToWorldTexture(shader, "desgreengrasstrckend")
		engineApplyShaderToWorldTexture(shader, "bow_church_grass_alt")
		engineApplyShaderToWorldTexture(shader, "grifnewtex1x_las")
		engineApplyShaderToWorldTexture(shader, "sjmlahus28")
		engineApplyShaderToWorldTexture(shader, "sl_sfngrass01")
		engineApplyShaderToWorldTexture(shader, "sl_sfngrssdrt01")
		engineApplyShaderToWorldTexture(shader, "des_scrub1_dirt1a")
		engineApplyShaderToWorldTexture(shader, "desertgryard256grs2")
		engineApplyShaderToWorldTexture(shader, "sfn_rockhole")
		engineApplyShaderToWorldTexture(shader, "sfn_rocktbrn128")
		engineApplyShaderToWorldTexture(shader, "sfncn_rockgrass3")
		engineApplyShaderToWorldTexture(shader, "sfncn_rockgrass4")
		engineApplyShaderToWorldTexture(shader, "sjmscorclawn")
		engineApplyShaderToWorldTexture(shader, "dirtkb_64hv")
		engineApplyShaderToWorldTexture(shader, "grasslong256")
		engineApplyShaderToWorldTexture(shader, "grasstype4blndtodirt")
		engineApplyShaderToWorldTexture(shader, "grasstype10_4blend")
		engineApplyShaderToWorldTexture(shader, "dirtgaz64b")
		engineApplyShaderToWorldTexture(shader, "forestfloorblendb")
		engineApplyShaderToWorldTexture(shader, "grass_dirt_64hv")
		engineApplyShaderToWorldTexture(shader, "grasstype4_10")
		engineApplyShaderToWorldTexture(shader, "des_dirtgrassmixc")
		engineApplyShaderToWorldTexture(shader, "sfn_grass1")
		engineApplyShaderToWorldTexture(shader, "sfn_rockgrass10")
		engineApplyShaderToWorldTexture(shader, "grasstype4_staw")
		engineApplyShaderToWorldTexture(shader, "desmuddesgrsblend")
		engineApplyShaderToWorldTexture(shader, "desmudgrass")
		engineApplyShaderToWorldTexture(shader, "desertstones256grass")
		engineApplyShaderToWorldTexture(shader, "grassdeep2")
		engineApplyShaderToWorldTexture(shader, "grass_dry_64hv")
		engineApplyShaderToWorldTexture(shader, "grass128hv_blend_")
		engineApplyShaderToWorldTexture(shader, "grasspatch_64hv")
		engineApplyShaderToWorldTexture(shader, "ws_traingravelblend")
		engineApplyShaderToWorldTexture(shader, "grasstype7")
		engineApplyShaderToWorldTexture(shader, "golf_fairway3")

		-- ПЕСОК ТРАВА СВЕРХУ

		local texture = dxCreateTexture("img/des_scrub1_dirt1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "des_scrub1_dirt1")
		engineApplyShaderToWorldTexture(shader, "des_grass2dirt1")
		engineApplyShaderToWorldTexture(shader, "des_dirt2dedgrass")
		engineApplyShaderToWorldTexture(shader, "desgrasandblend")
		engineApplyShaderToWorldTexture(shader, "des_dirt1_grass")

		-- КАМЕНЬ ТРАВА СВЕРХУ

		local texture = dxCreateTexture("img/sw_stonesgrass.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sw_stonesgrass")
		engineApplyShaderToWorldTexture(shader, "grassbrn2rockbrng")
		engineApplyShaderToWorldTexture(shader, "desclifftypebsmix")
		engineApplyShaderToWorldTexture(shader, "desertgravelgrassroad")
		engineApplyShaderToWorldTexture(shader, "desertgravelgrass256")
		engineApplyShaderToWorldTexture(shader, "grasstype5_dirt")
		engineApplyShaderToWorldTexture(shader, "rocktq128_grass4blend")
		engineApplyShaderToWorldTexture(shader, "cw2_mountdirt2forest")
		engineApplyShaderToWorldTexture(shader, "cw2_mountdirt2grass")
		engineApplyShaderToWorldTexture(shader, "rocktq128_forestblend2")
		engineApplyShaderToWorldTexture(shader, "forest_rocks")
		engineApplyShaderToWorldTexture(shader, "cuntbrnclifftop")
		engineApplyShaderToWorldTexture(shader, "rocktq128_forestblend")
		engineApplyShaderToWorldTexture(shader, "forestfloor_sones256")
		engineApplyShaderToWorldTexture(shader, "grass4dirtytrans")
		engineApplyShaderToWorldTexture(shader, "rocktq128blender")
		engineApplyShaderToWorldTexture(shader, "grass10dirt")
		engineApplyShaderToWorldTexture(shader, "grass10_stones256")
		engineApplyShaderToWorldTexture(shader, "grass10des_dirt2")
		engineApplyShaderToWorldTexture(shader, "forestfloor256_blenddirt")
		engineApplyShaderToWorldTexture(shader, "grass4_des_dirt2")
		engineApplyShaderToWorldTexture(shader, "des_dirt2grass")
		engineApplyShaderToWorldTexture(shader, "desegravelgrassroadla")
		engineApplyShaderToWorldTexture(shader, "redcliffroof_la")
		engineApplyShaderToWorldTexture(shader, "obhilltex1")

		-- КАМЕНЬ

		local texture = dxCreateTexture("img/sw_stones.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sw_stones")
		engineApplyShaderToWorldTexture(shader, "cs_rockdetail2")
		engineApplyShaderToWorldTexture(shader, "desertstones256")
		engineApplyShaderToWorldTexture(shader, "rocktq128_dirt")
		engineApplyShaderToWorldTexture(shader, "des_dirt2")
		engineApplyShaderToWorldTexture(shader, "des_dirt2stones")
		engineApplyShaderToWorldTexture(shader, "cw2_mountdirtscree")
		engineApplyShaderToWorldTexture(shader, "cw2_mountrock")
		engineApplyShaderToWorldTexture(shader, "cs_rockdetail")
		engineApplyShaderToWorldTexture(shader, "cw2_mountdirt")
		engineApplyShaderToWorldTexture(shader, "rocktq128")
		engineApplyShaderToWorldTexture(shader, "rock_country128")
		engineApplyShaderToWorldTexture(shader, "ws_patchygravel")
		engineApplyShaderToWorldTexture(shader, "bow_church_dirt")
		engineApplyShaderToWorldTexture(shader, "stones256")
		engineApplyShaderToWorldTexture(shader, "cst_rocksea_sfw")
		engineApplyShaderToWorldTexture(shader, "cst_rock_coast_sfw")
		engineApplyShaderToWorldTexture(shader, "newrockgrass_sfw")
		engineApplyShaderToWorldTexture(shader, "sw_rockgrass1")
		engineApplyShaderToWorldTexture(shader, "redclifftop256")
		engineApplyShaderToWorldTexture(shader, "lasclifface")
		engineApplyShaderToWorldTexture(shader, "stones256128")
		engineApplyShaderToWorldTexture(shader, "hllblf2_lae")
		engineApplyShaderToWorldTexture(shader, "des_redrockmid")
		engineApplyShaderToWorldTexture(shader, "des_redrockbot")
		engineApplyShaderToWorldTexture(shader, "des_redrock2")
		engineApplyShaderToWorldTexture(shader, "des_redrock1")
		engineApplyShaderToWorldTexture(shader, "des_rocky1_dirt1")
		engineApplyShaderToWorldTexture(shader, "des_rocky1")
		engineApplyShaderToWorldTexture(shader, "rocktbrn_dirt2")
		engineApplyShaderToWorldTexture(shader, "rocktbrn128")
		engineApplyShaderToWorldTexture(shader, "des_yelrock")
		engineApplyShaderToWorldTexture(shader, "sm_rock2_desert")
		engineApplyShaderToWorldTexture(shader, "hiwaygravel1_256")
		engineApplyShaderToWorldTexture(shader, "vgs_rockbot1a")
		engineApplyShaderToWorldTexture(shader, "vgs_rockmid1a")
		engineApplyShaderToWorldTexture(shader, "cw2_mounttrailblank")
		engineApplyShaderToWorldTexture(shader, "sfn_rock2")
		engineApplyShaderToWorldTexture(shader, "sfn_rockgrass1")
		engineApplyShaderToWorldTexture(shader, "des_crackeddirt1")


		-- ПЕСОК ТРАВА СЛЕВА

		local texture = dxCreateTexture("img/sw_sandgrass.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sw_sandgrass")
		engineApplyShaderToWorldTexture(shader, "des_dirt1grass")

		local texture = dxCreateTexture("img/des_dirttrack1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "des_dirttrack1")
		engineApplyShaderToWorldTexture(shader, "des_dirttrack1r")
		engineApplyShaderToWorldTexture(shader, "des_dirttrackl")
		engineApplyShaderToWorldTexture(shader, "des_pave_trackstart")
		engineApplyShaderToWorldTexture(shader, "des_oldrunwayblend")
		engineApplyShaderToWorldTexture(shader, "des_dirt2track")
		engineApplyShaderToWorldTexture(shader, "des_dirt2 trackl")

		local texture = dxCreateTexture("img/grifnewtex1b.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "grifnewtex1b")
		engineApplyShaderToWorldTexture(shader, "golf_gravelpath")
		engineApplyShaderToWorldTexture(shader, "grass_path_128hv")
		

		-- ДОРОЖКИ С КАМНЕМ

		local texture = dxCreateTexture("img/sw_rockgrassb1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sw_rockgrassb1")
		engineApplyShaderToWorldTexture(shader, "grassbrn2rockbrn")
		
		local texture = dxCreateTexture("img/rocktbrn128blnd.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "rocktbrn128blnd")
		engineApplyShaderToWorldTexture(shader, "dirtblendlit")
		engineApplyShaderToWorldTexture(shader, "rocktbrn128blndlit")

		local texture = dxCreateTexture("img/golf_grassrock.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "golf_grassrock")
		engineApplyShaderToWorldTexture(shader, "rock_country128blnd")
	
		local texture = dxCreateTexture("img/desstones_dirt1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "desstones_dirt1")

		local texture = dxCreateTexture("img/des_dirt2blend.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "des_dirt2blend")
		engineApplyShaderToWorldTexture(shader, "hiway2sand1a")
		engineApplyShaderToWorldTexture(shader, "con2sand1a")
		engineApplyShaderToWorldTexture(shader, "con2sand1b")

		local texture = dxCreateTexture("img/desgrasandblend.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "desgrasandblend")
		engineApplyShaderToWorldTexture(shader, "ws_drysand2grass")
		engineApplyShaderToWorldTexture(shader, "des_dirt1grass")
		engineApplyShaderToWorldTexture(shader, "sw_sandgrass4")
		engineApplyShaderToWorldTexture(shader, "grasstype5_desdirt")
		engineApplyShaderToWorldTexture(shader, "grasstype5_desdirt")

		local texture = dxCreateTexture("img/cw2_mounttrail.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "cw2_mounttrail")
		engineApplyShaderToWorldTexture(shader, "cw2_mountroad")
		
		local texture = dxCreateTexture("img/forest_rocks.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "forest_rocks")
		engineApplyShaderToWorldTexture(shader, "grasstype4blndtomud")
		engineApplyShaderToWorldTexture(shader, "cuntbrncliffbtmbmp")
		engineApplyShaderToWorldTexture(shader, "des_dirt2grgrass")
		engineApplyShaderToWorldTexture(shader, "forestfloor256mudblend")
		engineApplyShaderToWorldTexture(shader, "bow_church_dirt_to_grass_side_t")
		engineApplyShaderToWorldTexture(shader, "des_dirt2gygrass")
		engineApplyShaderToWorldTexture(shader, "blendrock2grgrass")
		
		local texture = dxCreateTexture("img/dirttracksgrass256.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "dirttracksgrass256")
		engineApplyShaderToWorldTexture(shader, "cw2_weeroad1")
		engineApplyShaderToWorldTexture(shader, "dirttracksforest")
		engineApplyShaderToWorldTexture(shader, "sw_farmroad01")
		engineApplyShaderToWorldTexture(shader, "grassdirtblend")
		engineApplyShaderToWorldTexture(shader, "desmudtrail2")
		engineApplyShaderToWorldTexture(shader, "desmudtrail")

		local texture = dxCreateTexture("img/newcrop3.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "newcrop3")
		engineApplyShaderToWorldTexture(shader, "grassgrnbrnx256")

		-- ДЕРЕВЬЯ

		local texture = dxCreateTexture("img/gen_log.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "gen_log")
		engineApplyShaderToWorldTexture(shader, "sm_redwood_bark")
		engineApplyShaderToWorldTexture(shader, "cj_darkwood")
		engineApplyShaderToWorldTexture(shader, "sm_bark_light")
		engineApplyShaderToWorldTexture(shader, "veg_bevtreebase")

		local texture = dxCreateTexture("img/elm_treegrn2.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "elm_treegrn4")
		engineApplyShaderToWorldTexture(shader, "elm_treegrn2")
		engineApplyShaderToWorldTexture(shader, "oakleaf2")
		engineApplyShaderToWorldTexture(shader, "oakleaf1")

		local texture = dxCreateTexture("img/locustbra.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "locustbra")

		local texture = dxCreateTexture("img/pinewood.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "pinewood")
		engineApplyShaderToWorldTexture(shader, "bchamae")
		engineApplyShaderToWorldTexture(shader, "oakbark64")
		engineApplyShaderToWorldTexture(shader, "tree_stub1")
		engineApplyShaderToWorldTexture(shader, "bfraxa1")
		engineApplyShaderToWorldTexture(shader, "bthuja1")
		engineApplyShaderToWorldTexture(shader, "bzelka1")
		engineApplyShaderToWorldTexture(shader, "bgleda0")

		-- РАСТЕНИЯ

		local texture = dxCreateTexture("img/sm_des_bush1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sm_des_bush1")

		local texture = dxCreateTexture("img/sm_des_bush2.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sm_des_bush2")

		local texture = dxCreateTexture("img/veg_bush2.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "veg_bush2")
		engineApplyShaderToWorldTexture(shader, "sm_agave_bloom")

		local texture = dxCreateTexture("img/kbtree3_test.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "kbtree3_test")

		local texture = dxCreateTexture("img/txgrass0_1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "txgrass0_1")
		engineApplyShaderToWorldTexture(shader, "sm_des_bush3")

		local texture = dxCreateTexture("img/newtreeleaves128.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "newtreeleaves128")
		engineApplyShaderToWorldTexture(shader, "newtreed256")
		engineApplyShaderToWorldTexture(shader, "pinelo128")
		engineApplyShaderToWorldTexture(shader, "sm_agave_1")
		engineApplyShaderToWorldTexture(shader, "sm_josh_leaf")

		local texture = dxCreateTexture("img/oak2b.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "oak2b")
		engineApplyShaderToWorldTexture(shader, "newtreeleavesb128")
		engineApplyShaderToWorldTexture(shader, "sm_agave_2")
		engineApplyShaderToWorldTexture(shader, "sm_minipalm1")

		-- local texture = dxCreateTexture("img/sm_redwood_branch.dds")
		-- local shader = dxCreateShader("shader.fx")
		-- dxSetShaderValue(shader, "gTexture", texture)
		-- engineApplyShaderToWorldTexture(shader, "veg_largefurs06")
		-- engineApplyShaderToWorldTexture(shader, "veg_largefurs05")

		local texture = dxCreateTexture("img/sm_pinetreebit.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sm_pinetreebit")
		engineApplyShaderToWorldTexture(shader, "sm_redwood_branch")

		local texture = dxCreateTexture("img/txgrass1_1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "txgrass1_1")

		local texture = dxCreateTexture("img/planta256.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "planta256")
		engineApplyShaderToWorldTexture(shader, "kbtree4_test")
		engineApplyShaderToWorldTexture(shader, "trunk3")

		local texture = dxCreateTexture("img/newhedgea.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "newhedgea")
		engineApplyShaderToWorldTexture(shader, "veg_hedge1_256")
		engineApplyShaderToWorldTexture(shader, "hedge1")
		engineApplyShaderToWorldTexture(shader, "dryhedge_128")
		engineApplyShaderToWorldTexture(shader, "hedgealphad1")
		engineApplyShaderToWorldTexture(shader, "aamanbev96x")
		engineApplyShaderToWorldTexture(shader, "hedge2")
		engineApplyShaderToWorldTexture(shader, "golf_hedge1")
		engineApplyShaderToWorldTexture(shader, "hedge")
		engineApplyShaderToWorldTexture(shader, "hedge1_law")

		local texture = dxCreateTexture("img/kb_ivy2_256.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "kb_ivy2_256")
		
		local texture = dxCreateTexture("img/cedarbare.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "cedarbare")
		engineApplyShaderToWorldTexture(shader, "cedarwee")

		-- КАБЕЛИ


		local texture = dxCreateTexture("img/cabel.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "telewires_law")

		local texture = dxCreateTexture("img/cabel2.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "telewireslong")

		local texture = dxCreateTexture("img/elmdead.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "elmdead")

		-- ТОЧКА

		local texture = dxCreateTexture("img/tochka.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "vgsn_nl_strip")
		engineApplyShaderToWorldTexture(shader, "custom_roadsign_text")
		engineApplyShaderToWorldTexture(shader, "ruffroadlas")

		-- ТАБЛИЧКИ

		local texture = dxCreateTexture("img/roadsback01_la.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "roadsback01_la")
		engineApplyShaderToWorldTexture(shader, "sw_roadsign")

		-- МУСОР

		local texture = dxCreateTexture("img/musor.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "gen_bin_bag")

		-- МУСОРКА
		
		local texture = dxCreateTexture("img/musorka.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "cj_dump")

		-- КОРОБКА
		
		local texture = dxCreateTexture("img/box.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "gen_box")

		-- ПАСХАЛКА

		local texture = dxCreateTexture("img/cj_gas_can.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "cj_gas_can")

		-- БАРДЮРЫ

		local texture = dxCreateTexture("img/sf_pave6.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "vegaspavement2_256")
		engineApplyShaderToWorldTexture(shader, "blendpavement2b_256")
		engineApplyShaderToWorldTexture(shader, "hiwayinside5_256")
		engineApplyShaderToWorldTexture(shader, "hiwayinside4_256")
		engineApplyShaderToWorldTexture(shader, "cos_hiwayins_256")
		engineApplyShaderToWorldTexture(shader, "cos_hiwayout_256")
		engineApplyShaderToWorldTexture(shader, "sjmhoodlawn41")
		engineApplyShaderToWorldTexture(shader, "sidelatino1_lae")
		engineApplyShaderToWorldTexture(shader, "sl_pavebutt1")
		engineApplyShaderToWorldTexture(shader, "easykerb")
		engineApplyShaderToWorldTexture(shader, "sjmhoodlawn42")
		engineApplyShaderToWorldTexture(shader, "sidewgrass1")
		engineApplyShaderToWorldTexture(shader, "craproad6_lae")
		engineApplyShaderToWorldTexture(shader, "pavebsand256")
		engineApplyShaderToWorldTexture(shader, "kbpavement_test")
		engineApplyShaderToWorldTexture(shader, "craproad5_lae")
		engineApplyShaderToWorldTexture(shader, "laroad_offroad1")
		engineApplyShaderToWorldTexture(shader, "sidewgrass2")
		engineApplyShaderToWorldTexture(shader, "sidewgrass3")
		engineApplyShaderToWorldTexture(shader, "sjmndukwal2")
		engineApplyShaderToWorldTexture(shader, "vegasdirtypave2_256")
		engineApplyShaderToWorldTexture(shader, "vegasdirtypave1_256")
		engineApplyShaderToWorldTexture(shader, "blendpavement2_256")
		engineApplyShaderToWorldTexture(shader, "hiwayinside2_256")
		engineApplyShaderToWorldTexture(shader, "hiwayinsideblend1_256")
		engineApplyShaderToWorldTexture(shader, "hiwayinsideblend2_256")
		engineApplyShaderToWorldTexture(shader, "hiwayinside_256")
		engineApplyShaderToWorldTexture(shader, "vgsn_road2sand02")
		engineApplyShaderToWorldTexture(shader, "pavebsandend")
		engineApplyShaderToWorldTexture(shader, "pav_brngrass")
		engineApplyShaderToWorldTexture(shader, "sf_pave6")
		engineApplyShaderToWorldTexture(shader, "dt_road2grasstype4")
		engineApplyShaderToWorldTexture(shader, "ws_nicepave")
		engineApplyShaderToWorldTexture(shader, "sidewalk4_lae")
		engineApplyShaderToWorldTexture(shader, "kbpavementblend")
		engineApplyShaderToWorldTexture(shader, "sl_pavebutt2")
		engineApplyShaderToWorldTexture(shader, "pavemiddirt_law")
	
		-- БАРДЮРЫ 2

		local texture = dxCreateTexture("img/dockpave_256.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "grassdry_path_128hv")
		engineApplyShaderToWorldTexture(shader, "grass_concpath2")
		engineApplyShaderToWorldTexture(shader, "dockpave_256")
		engineApplyShaderToWorldTexture(shader, "des_roadedge2")
		engineApplyShaderToWorldTexture(shader, "brngrss2stones")
		engineApplyShaderToWorldTexture(shader, "des_roadedge1")
		engineApplyShaderToWorldTexture(shader, "newpavement")
		engineApplyShaderToWorldTexture(shader, "macpath_lae")

		-- БАРДЮРЫ 3

		local texture = dxCreateTexture("img/dockpave_257.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "stormdrain5_nt")
		engineApplyShaderToWorldTexture(shader, "concretedust2_256128")
		engineApplyShaderToWorldTexture(shader, "backalley1_lae")

		-- ЛУНА

		local texture = dxCreateTexture("img/coronamoon.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "coronamoon")

		local texture = dxCreateTexture("img/hospital8t_sfw.png")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "hospital8t_sfw")

		-- ПАРКИНГИ

		local texture = dxCreateTexture("img/concretedust2_line.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "concretedust2_line")

		local texture = dxCreateTexture("img/badmarb1_lan.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "badmarb1_lan")
		engineApplyShaderToWorldTexture(shader, "ceiling_256")
		engineApplyShaderToWorldTexture(shader, "paveslab1")
		engineApplyShaderToWorldTexture(shader, "ws_corr_metal1")
		engineApplyShaderToWorldTexture(shader, "ws_altz_wall7_top")
		engineApplyShaderToWorldTexture(shader, "ws_blackmarble")
		engineApplyShaderToWorldTexture(shader, "ws_blackmarblelod")
		engineApplyShaderToWorldTexture(shader, "calfederal5")
		engineApplyShaderToWorldTexture(shader, "calfederal4")
		engineApplyShaderToWorldTexture(shader, "concretewall22_256")
		engineApplyShaderToWorldTexture(shader, "sf_pave2")
		engineApplyShaderToWorldTexture(shader, "retainwall1")
		engineApplyShaderToWorldTexture(shader, "roughwall_kb_semless")
		engineApplyShaderToWorldTexture(shader, "cobbles_kb_256")
		engineApplyShaderToWorldTexture(shader, "coasty_bit6_sfe")
		engineApplyShaderToWorldTexture(shader, "pavementhexagon")
		engineApplyShaderToWorldTexture(shader, "vegaspawnwall02_128")
		engineApplyShaderToWorldTexture(shader, "ws_altz_wall1")
		engineApplyShaderToWorldTexture(shader, "compcouwall1")
		engineApplyShaderToWorldTexture(shader, "ws_floortiles4")
		engineApplyShaderToWorldTexture(shader, "la_tilered")
		engineApplyShaderToWorldTexture(shader, "greyground12802")
		engineApplyShaderToWorldTexture(shader, "luxorfloor02_128")
		engineApplyShaderToWorldTexture(shader, "ws_stationfloor")
		engineApplyShaderToWorldTexture(shader, "hilcouwall2")
		engineApplyShaderToWorldTexture(shader, "concretenewb256128")
		engineApplyShaderToWorldTexture(shader, "dock1")

		-- ЗВЕЗДЫ


		local texture = dxCreateTexture("img/coronastar.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "coronastar")


		local texture = dxCreateTexture("img/vgnptrpump1_256.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "vgnptrpump1_256")

		local texture = dxCreateTexture("img/vgnptrpump2_128.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "vgnptrpump2_128")

		-- МОСТЫ

		local texture = dxCreateTexture("img/ws_goldengate5.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_goldengate5")

		local texture = dxCreateTexture("img/ws_goldengate1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_goldengate1")
		engineApplyShaderToWorldTexture(shader, "gg_mid_lod")
		engineApplyShaderToWorldTexture(shader, "ws_oldpainted2")
		engineApplyShaderToWorldTexture(shader, "ws_goldengate5bnoalpha")

		local texture = dxCreateTexture("img/ws_goldengate4.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_goldengate4")

		local texture = dxCreateTexture("img/ws_goldengate2.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_goldengate2")
		engineApplyShaderToWorldTexture(shader, "ws_goldengate5")

		-- ВОРОТА ГАРАЖНЫЕ


		local texture = dxCreateTexture("img/loadingdoorclean.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "loadingdoorclean")
		engineApplyShaderToWorldTexture(shader, "tramdoors_sfw")
		engineApplyShaderToWorldTexture(shader, "bow_loadingbaydoor")
		engineApplyShaderToWorldTexture(shader, "alleydoor8")
		engineApplyShaderToWorldTexture(shader, "bow_loadingbay_door")
		engineApplyShaderToWorldTexture(shader, "bow_load_door")


		--------------------
		local texture = dxCreateTexture("img/ws_wangcar1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_wangcar1")

		-- КАНАЛИЗАЦИЯ

		local texture = dxCreateTexture("img/stormdrain1_nt.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "stormdrain1_nt")
		engineApplyShaderToWorldTexture(shader, "lasrmd3_sjm")

		-- СТЕНЫ ЗДАНИЙ ЛС

		local texture = dxCreateTexture("img/gm_labuld2_b.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "gm_labuld2_b")
		engineApplyShaderToWorldTexture(shader, "gm_labuld2_a")
		engineApplyShaderToWorldTexture(shader, "sl_whitewash1")
		engineApplyShaderToWorldTexture(shader, "concpanel_la")
		engineApplyShaderToWorldTexture(shader, "ws_white_wall1")
		engineApplyShaderToWorldTexture(shader, "concretenewb256")
		engineApplyShaderToWorldTexture(shader, "bow_sub_wallshine")
		engineApplyShaderToWorldTexture(shader, "bow_sub_walltiles")
		engineApplyShaderToWorldTexture(shader, "ws_tunnelwall1")
		engineApplyShaderToWorldTexture(shader, "ws_sub_pen_conc2")
		engineApplyShaderToWorldTexture(shader, "ws_sub_pen_conc")
		engineApplyShaderToWorldTexture(shader, "ws_sub_pen_conc4")
		engineApplyShaderToWorldTexture(shader, "sea_wall_temp")
		engineApplyShaderToWorldTexture(shader, "fancy_slab128")
		engineApplyShaderToWorldTexture(shader, "coasty_bit4_sfe")
		engineApplyShaderToWorldTexture(shader, "stonewall2_la")
		engineApplyShaderToWorldTexture(shader, "mono1_sfe")
		engineApplyShaderToWorldTexture(shader, "2hospital2sfw")
		engineApplyShaderToWorldTexture(shader, "2hospital3sfw")
		engineApplyShaderToWorldTexture(shader, "2hospital1sfw")
		engineApplyShaderToWorldTexture(shader, "2hospital5sfw")
		engineApplyShaderToWorldTexture(shader, "2hospital4sfw")
		engineApplyShaderToWorldTexture(shader, "2hospital6sfw")
		engineApplyShaderToWorldTexture(shader, "2hospital7sfw")
		engineApplyShaderToWorldTexture(shader, "ws_breezeblocks")
		engineApplyShaderToWorldTexture(shader, "tramstation3_sfw")
		engineApplyShaderToWorldTexture(shader, "tramstation2_sfw")
		engineApplyShaderToWorldTexture(shader, "ws_slatetiles")
		engineApplyShaderToWorldTexture(shader, "des_ranchwall1")
		engineApplyShaderToWorldTexture(shader, "gb_nastybar20")
		engineApplyShaderToWorldTexture(shader, "stonewall_la")
		engineApplyShaderToWorldTexture(shader, "asanmonhrbwal1")
		engineApplyShaderToWorldTexture(shader, "sw_brewbrick01")
		engineApplyShaderToWorldTexture(shader, "gb_nastybar03")
		engineApplyShaderToWorldTexture(shader, "badhousewall01_128")
		engineApplyShaderToWorldTexture(shader, "upt_conc floor")
		engineApplyShaderToWorldTexture(shader, "newall10")
		engineApplyShaderToWorldTexture(shader, "sw_stresswall1")
		engineApplyShaderToWorldTexture(shader, "taxi_256")
		engineApplyShaderToWorldTexture(shader, "vgnammuwal3")
		engineApplyShaderToWorldTexture(shader, "vgnstripwal1_128")
		engineApplyShaderToWorldTexture(shader, "vgnalleywall1_256")
		engineApplyShaderToWorldTexture(shader, "vgs_rockwall01_128")
		engineApplyShaderToWorldTexture(shader, "ws_altz_wall6big")
		engineApplyShaderToWorldTexture(shader, "ws_sandstone1")
		engineApplyShaderToWorldTexture(shader, "ws_apartmentmankyb2")
		engineApplyShaderToWorldTexture(shader, "vgschurchwall04_256")
		engineApplyShaderToWorldTexture(shader, "vgnhsewall1_256")
		engineApplyShaderToWorldTexture(shader, "stonewall3_la")
		engineApplyShaderToWorldTexture(shader, "vgnlowbuild3_256")
		engineApplyShaderToWorldTexture(shader, "bluapartwall1_256")
		engineApplyShaderToWorldTexture(shader, "alleywall3")
		engineApplyShaderToWorldTexture(shader, "gb_truckdepot18")
		engineApplyShaderToWorldTexture(shader, "latranswall1")

		local texture = dxCreateTexture("img/gm_labuld2_c.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "gm_labuld2_c")
		engineApplyShaderToWorldTexture(shader, "tramstation1_sfw")

		local texture = dxCreateTexture("img/sl_pendant1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sl_pendant1")

		local texture = dxCreateTexture("img/ws_apartmentmankyb1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_apartmentmankyb1")

		local texture = dxCreateTexture("img/ws_apartmentmankygreen1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_apartmentmankygreen1")

		local texture = dxCreateTexture("img/ws_apartmentmankypeach1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_apartmentmankypeach1")

		local texture = dxCreateTexture("img/staddoors1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "staddoors1")
		engineApplyShaderToWorldTexture(shader, "sf_hospitaldr1")
		engineApplyShaderToWorldTexture(shader, "ws_airportdoors1")

		local texture = dxCreateTexture("img/wolf1.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "wolf1 copy")
		engineApplyShaderToWorldTexture(shader, "sf_hospitaldr2")
		engineApplyShaderToWorldTexture(shader, "ws_airportwin2")

		local texture = dxCreateTexture("img/sf_windos_4.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sf_windos_4")
		engineApplyShaderToWorldTexture(shader, "flmngo03_128")

		local texture = dxCreateTexture("img/ws_skywins4.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_skywins4")
		engineApplyShaderToWorldTexture(shader, "policeha02_128")

		-- ВОРОТА ГАРАЖНЫЕ


		local texture = dxCreateTexture("img/loadingdoorclean.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "circus_gls_03")
		engineApplyShaderToWorldTexture(shader, "ws_rollerdoor_silver")
		engineApplyShaderToWorldTexture(shader, "garargeb2")

		-- СТЕКЛО


		local texture = dxCreateTexture("img/ws_carshowwin1.png")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "ws_carshowwin1")
		engineApplyShaderToWorldTexture(shader, "ws_carshowdoor1")
		engineApplyShaderToWorldTexture(shader, "ws_trainstationwin1")


		-- ВЫСОТКА ЛС


		local texture = dxCreateTexture("img/zdanie1/sl_skyscrpr03.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sl_skyscrpr03")
		engineApplyShaderToWorldTexture(shader, "lan2skyscra5_lod")
		engineApplyShaderToWorldTexture(shader, "lan2skyscra5_lod")
		engineApplyShaderToWorldTexture(shader, "ws_skywinsgreen")
		engineApplyShaderToWorldTexture(shader, "ws_skywinsgreenlod")

		local texture = dxCreateTexture("img/zdanie1/sl_skyscrpr02.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "sl_skyscrpr02")
		engineApplyShaderToWorldTexture(shader, "lan2lodbuild09")
		engineApplyShaderToWorldTexture(shader, "downtwin24")
		engineApplyShaderToWorldTexture(shader, "ws_skyscraperwin1")


		-- КОНТЕЙНЕРЫ


		-- КРАСНЫЕ

		local texture = dxCreateTexture("img/frate_doors64yellow.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "frate_doors64yellow")

		local texture = dxCreateTexture("img/vgndwntwnrf2_128.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "vgndwntwnrf2_128")
		engineApplyShaderToWorldTexture(shader, "ctmall07")

		local texture = dxCreateTexture("img/frate64_white.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "airportmetalwall256")
		engineApplyShaderToWorldTexture(shader, "vgnwrehsewal1_256")
		engineApplyShaderToWorldTexture(shader, "vgnwrehsewal2_256")

		local texture = dxCreateTexture("img/frate64_yellow.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "frate64_yellow")
		engineApplyShaderToWorldTexture(shader, "vgswrehouse01_128")
		engineApplyShaderToWorldTexture(shader, "browntin1")
		engineApplyShaderToWorldTexture(shader, "ws_corr_1_red")

		-- ЖЁЛТЫЕ

		local texture = dxCreateTexture("img/frate_doors128red.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "frate_doors128red")

		local texture = dxCreateTexture("img/frate64_red.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "frate64_red")

		-- СИНИЕ

		local texture = dxCreateTexture("img/frate_doors64.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "frate_doors64")
		engineApplyShaderToWorldTexture(shader, "frate_doors64128")

		local texture = dxCreateTexture("img/frate64_blue.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "frate64_blue")
		engineApplyShaderToWorldTexture(shader, "vgspawnroof02_128")
		engineApplyShaderToWorldTexture(shader, "vgspawnroof01_128")

		-- ПОДЪЕМНЫЙ КРАН

		-- local texture = dxCreateTexture("img/yellowscum64.dds")
		-- local shader = dxCreateShader("shader.fx")
		-- dxSetShaderValue(shader, "gTexture", texture)
		-- engineApplyShaderToWorldTexture(shader, "ws_goldengate2")
		-- engineApplyShaderToWorldTexture(shader, "ws_goldengate5b")
		-- engineApplyShaderToWorldTexture(shader, "redmetal")
		-- engineApplyShaderToWorldTexture(shader, "ws_oldpaintedyello")
		-- engineApplyShaderToWorldTexture(shader, "lod_redmetal")

		-- КОРАБЛЬ

		local texture = dxCreateTexture("img/boatside2_256.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "boatside2_256")

		local texture = dxCreateTexture("img/mp_cellwalla_256.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "mp_cellwalla_256")
		engineApplyShaderToWorldTexture(shader, "bandingblue_64")
		engineApplyShaderToWorldTexture(shader, "mp_cellwall_256")
		engineApplyShaderToWorldTexture(shader, "lamppost")
		engineApplyShaderToWorldTexture(shader, "metal1_128")
		engineApplyShaderToWorldTexture(shader, "lampost_16clr")
		engineApplyShaderToWorldTexture(shader, "des_facmetalsoild")
		engineApplyShaderToWorldTexture(shader, "bluemetal02")
		engineApplyShaderToWorldTexture(shader, "bluemetal")
		engineApplyShaderToWorldTexture(shader, "ws_wangcar2")
		engineApplyShaderToWorldTexture(shader, "cabin5")

		local texture = dxCreateTexture("img/yellowscum64.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "yellowscum64")

		local texture = dxCreateTexture("img/bluemetal03.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "bluemetal03")
		engineApplyShaderToWorldTexture(shader, "boatfunnel1_128")

		local texture = dxCreateTexture("img/wallbluetinge256.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "wallbluetinge256")

		local texture = dxCreateTexture("img/steel256128.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "steel256128")
		engineApplyShaderToWorldTexture(shader, "metalox64")
		engineApplyShaderToWorldTexture(shader, "gen_metal")
		engineApplyShaderToWorldTexture(shader, "oilband_64")


		-- БЕТОН

		local texture = dxCreateTexture("img/concroadslab_256.dds")
		local shader = dxCreateShader("shader.fx")
		dxSetShaderValue(shader, "gTexture", texture)
		engineApplyShaderToWorldTexture(shader, "concroadslab_256")
		engineApplyShaderToWorldTexture(shader, "block2")
		engineApplyShaderToWorldTexture(shader, "des_dam_conc")
		engineApplyShaderToWorldTexture(shader, "ws_trans_concr")
		engineApplyShaderToWorldTexture(shader, "heliconcrete")
		engineApplyShaderToWorldTexture(shader, "block")
		engineApplyShaderToWorldTexture(shader, "comptwall30")
		engineApplyShaderToWorldTexture(shader, "macbrij2_lae")
		engineApplyShaderToWorldTexture(shader, "macbrij1_lae")
		engineApplyShaderToWorldTexture(shader, "pierbild01_law")
		engineApplyShaderToWorldTexture(shader, "whiteconc01")
		engineApplyShaderToWorldTexture(shader, "law_yellow2")
		engineApplyShaderToWorldTexture(shader, "vgswrehouse02_128")
		engineApplyShaderToWorldTexture(shader, "highshopwall1256")
		engineApplyShaderToWorldTexture(shader, "concreteblock_256")
		engineApplyShaderToWorldTexture(shader, "ws_airportwall2")
		engineApplyShaderToWorldTexture(shader, "ws_airportwall1")
		engineApplyShaderToWorldTexture(shader, "ws_whitewall2_top")
		engineApplyShaderToWorldTexture(shader, "ws_whitewall2_bottom")
		engineApplyShaderToWorldTexture(shader, "iron")
		engineApplyShaderToWorldTexture(shader, "sl_skyscrpr02wall1")
		engineApplyShaderToWorldTexture(shader, "sl_concretewall1")
		engineApplyShaderToWorldTexture(shader, "lacreamwall1")
		engineApplyShaderToWorldTexture(shader, "stonesandkb2_128")
		engineApplyShaderToWorldTexture(shader, "wallgreyred128")
		engineApplyShaderToWorldTexture(shader, "stormdrain6")
		engineApplyShaderToWorldTexture(shader, "block2_high")
		engineApplyShaderToWorldTexture(shader, "newall5-2")
		engineApplyShaderToWorldTexture(shader, "block2_low")
		engineApplyShaderToWorldTexture(shader, "stormdrain2_nt")
		engineApplyShaderToWorldTexture(shader, "stormdrain4_nt")
		engineApplyShaderToWorldTexture(shader, "pavea256")
		engineApplyShaderToWorldTexture(shader, "ws_tunnelwall2")
		engineApplyShaderToWorldTexture(shader, "ws_rottenwall")
		engineApplyShaderToWorldTexture(shader, "gb_nastybar02")
		engineApplyShaderToWorldTexture(shader, "concretebigb256128")
		engineApplyShaderToWorldTexture(shader, "forumstand1_lae")
		engineApplyShaderToWorldTexture(shader, "was_scrpyd_wall_in_hngr")
		engineApplyShaderToWorldTexture(shader, "trail_wall1")
		engineApplyShaderToWorldTexture(shader, "concretewall22b")
		engineApplyShaderToWorldTexture(shader, "des_tunnellight")
		engineApplyShaderToWorldTexture(shader, "greyground256128")
		engineApplyShaderToWorldTexture(shader, "studwalltop_law")
		engineApplyShaderToWorldTexture(shader, "stormdrain3_nt")
		engineApplyShaderToWorldTexture(shader, "tanstucco1_la")
		engineApplyShaderToWorldTexture(shader, "stormdrain1b_sl")
		engineApplyShaderToWorldTexture(shader, "lasrmd2_sjm")
		engineApplyShaderToWorldTexture(shader, "macbrij4_lae")
		engineApplyShaderToWorldTexture(shader, "ws_altz_wall10")
		engineApplyShaderToWorldTexture(shader, "ws_altz_wall10")
		engineApplyShaderToWorldTexture(shader, "ws_altz_wall10b")
		engineApplyShaderToWorldTexture(shader, "concreteslab_small")
		engineApplyShaderToWorldTexture(shader, "ws_carparkwall1")
		engineApplyShaderToWorldTexture(shader, "ws_rotten_concrete1")
		engineApplyShaderToWorldTexture(shader, "vgs_shopwall01_128")
		engineApplyShaderToWorldTexture(shader, "ws_sub_pen_conc3")
		engineApplyShaderToWorldTexture(shader, "conc_wall_stripd2128h")
		engineApplyShaderToWorldTexture(shader, "conc_wall2_128h")
		engineApplyShaderToWorldTexture(shader, "whitewall256")
		engineApplyShaderToWorldTexture(shader, "wallwashvc128")
		engineApplyShaderToWorldTexture(shader, "ws_freeway2")
		engineApplyShaderToWorldTexture(shader, "venwalkway_law")
		engineApplyShaderToWorldTexture(shader, "sw_pdground")
		engineApplyShaderToWorldTexture(shader, "sw_gasground")
		engineApplyShaderToWorldTexture(shader, "sw_gasground2")
		engineApplyShaderToWorldTexture(shader, "slab64")
		engineApplyShaderToWorldTexture(shader, "ws_oldpainted2rusty")
		engineApplyShaderToWorldTexture(shader, "ws_whiteplaster_btm")
		engineApplyShaderToWorldTexture(shader, "conc_wall_128h")
		engineApplyShaderToWorldTexture(shader, "lightwallv256")
		engineApplyShaderToWorldTexture(shader, "dirtyredwall512")
		engineApplyShaderToWorldTexture(shader, "comptwall23")



		
end



function updateShaders(state)
	if state then
		loadShaders()
	else
		unloadShaders()
	end
end

addEventHandler('onClientElementDataChange', root, function(dn)
	if dn ~= 'settings.detail' then return end
	if source ~= localPlayer then return end
	updateShaders(getElementData(localPlayer, 'settings.detail'))
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	updateShaders(getElementData(localPlayer, 'settings.detail'))
end)
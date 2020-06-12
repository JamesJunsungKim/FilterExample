#include <metal_stdlib>
using namespace metal;

#include <CoreImage/CoreImage.h>

extern "C" { namespace coreimage {
    
    float4 color1(sample_t s) {
        return s.grba;
    }
    
    float4 color2(sample_t s) {
        return float4(s.rgb, 0.5);
    }
    
    float4 color3(sample_t s) {
        return float4(s.r, s.b, s.g, 1);
    }
    
    float4 averageBlend(sample_t foreground, sample_t background) {
        return (foreground + background) / 2.0;
    }

    float2 warp1(destination des) {
        return float2(des.coord().y, des.coord().x);
    }
    
    float2 warp2(destination des) {
        return float2(des.coord().x * 2, des.coord().y * 2);
    }
    
    float2 warp3(destination des) {
        return float2(des.coord().x / 2, des.coord().y / 2);
    }
}}

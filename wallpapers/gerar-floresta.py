import random, math, sys, subprocess
random.seed(7)
W,H=1920,1080
def lerp(t):
    cs=[(0x1e,0x26,0x2a),(0x3d,0x48,0x4d),(0x5f,0x7a,0x68),(0xc9,0xb2,0x82),(0xe6,0x98,0x75)]
    t=min(t*1.25,0.999)*(len(cs)-1); i=int(t); f=t-i; a,b=cs[i],cs[i+1]
    return ''.join(f'{round(a[k]+(b[k]-a[k])*f):02x}' for k in range(3))
o=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}">',
] + [f'<rect y="{i*12}" width="{W}" height="13" fill="#{lerp(i/90)}"/>' for i in range(90)] + [
'<circle cx="1420" cy="430" r="80" fill="#f2e2b8" opacity="0.9"/>']
def serra(base,amp,cor,passo=40):
    pts=[(0,H)]; y=base
    for x in range(0,W+passo,passo):
        y=base+amp*math.sin(x/260+base)+random.uniform(-amp/3,amp/3)
        pts.append((x,y))
    pts.append((W,H))
    o.append(f'<polygon fill="{cor}" points="'+" ".join(f"{a:.0f},{b:.0f}" for a,b in pts)+'"/>')
def pinheiros(base,alt,cor,n):
    for _ in range(n):
        x=random.uniform(-20,W+20); h=alt*random.uniform(0.6,1.2); w=h*0.32; b=base+random.uniform(-15,25)
        for k in range(3):
            t=b-h*k*0.28; o.append(f'<polygon fill="{cor}" points="{x-w*(1-k*0.22):.0f},{t:.0f} {x:.0f},{t-h*0.5:.0f} {x+w*(1-k*0.22):.0f},{t:.0f}"/>')
        o.append(f'<rect fill="{cor}" x="{x-4:.0f}" y="{b:.0f}" width="8" height="40"/>')
serra(520,110,"#8a9a86",60); serra(620,80,"#6a8070",50)
o.append(f'<rect y="660" width="{W}" height="160" fill="#d3c6aa" opacity="0.10"/>')
pinheiros(800,170,"#45574c",45); serra(840,20,"#3a4a40")
pinheiros(920,230,"#2f3b35",35); serra(960,15,"#283029")
pinheiros(1060,320,"#1e2420",22)
o.append('</svg>')
# manda o svg direto pro ImageMagick pela entrada padrão, sem arquivo .svg no meio
subprocess.run(["convert","svg:-",sys.argv[1]],input="\n".join(o).encode(),check=True)
